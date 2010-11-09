//
//  FlipsideViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "FlipsideViewController.h"

#import "MixLightsAppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
  assignInProgress = NO;
  searchInProgress = NO;
}


- (IBAction)done:(id)sender
{
	if (!assignInProgress) {
		[self.delegate flipsideViewControllerDidFinish:self];
  }
}


- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc
{
  [super dealloc];
}


- (IBAction)editDone:(UIResponder *)aResponder
{
	[aResponder resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
	daliBridgeAddrField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"DaliBridgeIP"];
	[super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[[NSUserDefaults standardUserDefaults] setObject:daliBridgeAddrField.text forKey:@"DaliBridgeIP"];
	[super viewWillDisappear:animated];
}



#pragma mark direct command sending

- (void)sendCommandAnswer:(NSNumber *)aAnswer
{
	if (aAnswer) {
  	daliAnswerField.text = [NSString stringWithFormat:@"%02X",[aAnswer intValue]];
  }
  else {
  	daliAnswerField.text = @"n/a";
  }
}


- (IBAction)sendCommand:(id)sender
{
	// scan hex values
  // - bridge command
	NSScanner *scanner = [NSScanner scannerWithString:bridgeCmdField.text];
	unsigned bridgeCmd;
  if (![scanner scanHexInt:&bridgeCmd]) return; // nop
  // - DALI command
	scanner = [NSScanner scannerWithString:daliCmdField.text];
	unsigned daliCmd;
  if (![scanner scanHexInt:&daliCmd]) return; // nop
  // values ok, update texts
  bridgeCmdField.text = [NSString stringWithFormat:@"%02X",bridgeCmd];
  daliCmdField.text = [NSString stringWithFormat:@"%04X",daliCmd];
  // send
	[[MixLightsAppDelegate sharedAppDelegate].daliComm
  	sendDaliBridgeCommand:bridgeCmd dali1:(daliCmd>>8)&0xFF dali2:daliCmd&0xFF
    expectsAnswer:YES answerTarget:self selector:@selector(sendCommandAnswer:)
    timeout:1.0 // wait long enough
  ];
}


- (IBAction)sendDTRAndCommand:(id)sender
{
  // - DTR value
	unsigned dtr = [dtrValueField.text intValue];
  // send DTR
	[[MixLightsAppDelegate sharedAppDelegate].daliComm
		daliSend:0xA3 dali2:dtr
  ];
  // now send command itself
  [self sendCommand:sender];
}




- (void)blinkNewAddress
{
  for (int i=1; i<4; i++) {
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[DALIcomm daliAddressForLamp:newAddress]+1 dali2:5 duration:1]; // recall max
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[DALIcomm daliAddressForLamp:newAddress]+1 dali2:6 duration:1]; // recall min
  }
}



#pragma mark Finding next addressable ballast

- (void)queryBallast
{
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:[DALIcomm daliAddressForLamp:newAddress]+1 dali2:0x91 answerTarget:self selector:@selector(queryBallastResult:) timeout:0.3];
}


- (void)queryBallastResult:(NSNumber *)aAnswer
{
	if (!searchInProgress)
  	goto done; // stop search
	if (!aAnswer && noAnswerReps<3) {
  	noAnswerReps++;
  	[self performSelector:@selector(queryBallast) withObject:nil afterDelay:0.3];
    return;
  }
  // if no result so far, assume no ballast here
  if (!aAnswer) {
  	// query next
    newAddress++;
    if (newAddress>63) {
    	// none found
      [[[[UIAlertView alloc]
        initWithTitle: @"DALI ballast search"
        message: @"No more ballasts found"
        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil
      ] autorelease] show];
      // reset to 0 for next scan
      dtrValueField.text = @"0";
      goto done;
    }
    // visibly update
    dtrValueField.text = [NSString stringWithFormat:@"%d",newAddress];
  	// query next address
		noAnswerReps = 0;
  	[self performSelector:@selector(queryBallast) withObject:nil afterDelay:0.3];
    return;
  }
  else {
  	// found lamp at this address
    [[[[UIAlertView alloc]
      initWithTitle: @"DALI ballast search"
      message: [NSString stringWithFormat:@"Found ballast at address %d", newAddress]
      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil
    ] autorelease] show];
    // show which one it is
    [self blinkNewAddress];
    // next scan starting at next higher address
    dtrValueField.text = [NSString stringWithFormat:@"%d",newAddress+1];
    goto done;
  }
done:
  [progressSpinner stopAnimating];
  searchInProgress = NO;
  return;
}
  


- (IBAction)findNextAdressableBallast
{
	if (searchInProgress) {
  	searchInProgress = NO;
    return;
  }
	// where to start search
	newAddress = [dtrValueField.text intValue];
  if (newAddress<0 || newAddress>63) newAddress=0;
  // issue query ballast
  searchInProgress = YES;
  [progressSpinner startAnimating];
  noAnswerReps = 0;
  [self queryBallast];
}







#pragma mark Physical Address Assignment

- (void)endAssignAddress
{
	// terminate address mode
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xA1 dali2:0];
  // no longer in progress
  assignInProgress = NO;
  [progressSpinner stopAnimating];
}


- (IBAction)assignAddressPhysical
{
	// if pressed again, aborts
  if (assignInProgress) {
  	[self endAssignAddress];
    return;
  }
  // get new short address value (from DTR field)
	newAddress = [dtrValueField.text intValue];
  if (newAddress<0 || newAddress>63) return;
  // start
  [progressSpinner startAnimating];
  assignInProgress = YES;
  // Initialize address assignment for all Ballasts that don't have a short address
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:0xA5 dali2:(alsoWithShortAddrSwitch.isOn ? 0x00 : 0xFF) duration:1];
  // query short address until one responds
  [self performSelector:@selector(queryShortAddrAnswer:) withObject:nil afterDelay:0.7];
}


- (void)queryShortAddrAnswer:(NSNumber *)aAnswer
{
	if (assignInProgress) {
  	// waiting for selection
    if (!aAnswer) {
    	// no answer yet, schedule query
			[[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:0xBB dali2:0x00 answerTarget:self selector:@selector(queryShortAddrAnswer:) timeout:1.0];
    }
    else {
    	// answer received - one lamp is physically selected now
      // - program new address
			[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xB7 dali2:(newAddress<<1)+1 duration:0.5];
      // - verify it
		  noAnswerReps = 0; 
			[self verifyNewShortAddr];      
    }
  }
}


- (void)verifyNewShortAddr
{
  // query
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:0xB9 dali2:(newAddress<<1)+1 answerTarget:self selector:@selector(verifyShortAddrAnswer:)];	
}


- (void)verifyShortAddrAnswer:(NSNumber *)aAnswer
{
	if (!aAnswer && noAnswerReps<3) {
  	noAnswerReps++;
  	[self performSelector:@selector(verifyNewShortAddr) withObject:nil afterDelay:0.3];
  }
  [self displayAndEndAddressAssignWithSuccess:aAnswer!=nil];
}
  


- (void)displayAndEndAddressAssignWithSuccess:(BOOL)aSuccess
{
	// verified if aAnswer
  [[[[UIAlertView alloc]
  	initWithTitle: @"DALI address assignment"
    message: (aSuccess ? [NSString stringWithFormat:@"New address %d set and verified", newAddress] : @"Failed setting new address or no device found")
   	delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Continue",nil
  ] autorelease] show];
  if (aSuccess) {
    // next scan assigns one higher
    dtrValueField.text = [NSString stringWithFormat:@"%d",newAddress+1];
		// blink lamp
    [self blinkNewAddress];
	}
  // let alert decide whether to continue
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
  	case 0:
      // done, terminate
      [self endAssignAddress];
      break;
    case 1:
    	// re-start searching
      newAddress++;
		  [self startNewSearchUpwardsFrom:searchAddr+1]; // start one after known lowest address
      break;
  }
}




#pragma mark Random Address Search and Assignment

- (IBAction)assignAddressRandom
{
	// if pressed again, aborts
  if (assignInProgress) {
  	[self endAssignAddress]; // end
    return;
  }
  // get new short address value (from DTR field)
	newAddress = [dtrValueField.text intValue];
  if (newAddress<0 || newAddress>63) return;
  // start
  [progressSpinner startAnimating];
  assignInProgress = YES;
  // Initialize address assignment for all Ballasts that don't have a short address
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:0xA5 dali2:(alsoWithShortAddrSwitch.isOn ? 0x00 : 0xFF) duration:1];
  // randomize entire system if we are running through all ballasts
	if (alsoWithShortAddrSwitch.isOn) {
		NSLog(@"All ballasts affected -> Randomizing system");
		[[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:0xA7 dali2:0x00 duration:1];
  }
  [self startNewSearchUpwardsFrom:0]; // entire range
}
  

- (void)startNewSearchUpwardsFrom:(uint32_t)aMinSearchAddr
{
  // - init search vars
  searchH = 0xFF;
  searchM = 0xFF;
  searchL = 0xFF;
  searchMax = 0xFFFFFF;
  searchMin = aMinSearchAddr;
	searchAddr = (searchMax-aMinSearchAddr)/2+aMinSearchAddr; 
  noAnswerReps = 0;
	// run search
  [self nextCompare];
}


- (void)nextCompare
{
  // program search address
  // - searchH
  uint8_t by = (searchAddr>>16) & 0xFF;
  if (by!=searchH) {
    searchH = by;
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xB1 dali2:searchH];
  }
  // - searchM
  by = (searchAddr>>8) & 0xFF;
  if (by!=searchM) {
    searchM = by;
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xB3 dali2:searchM];
  }
  // - searchL
  by = (searchAddr) & 0xFF;
  if (by!=searchL) {
    searchL = by;
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xB5 dali2:searchL];
  }
  // let units compare
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:0xA9 dali2:00 answerTarget:self selector:@selector(compareResult:) timeout:0.3];
}


- (void)compareResult:(NSNumber *)aResult
{
	if (!aResult && noAnswerReps<3) {
  	noAnswerReps++;
    [self performSelector:@selector(nextCompare) withObject:nil afterDelay:0.03]; // try again to make sure we did not just miss a YES!
    return;
  }
	NSLog(@">>> compareResult = %s, search=0x%lX, searchMin=0x%lX, searchMax=0x%lX", aResult==nil ? "No " : "Yes", searchAddr, searchMin, searchMax);
	// count this as a result, next will start again
  noAnswerReps = 0;
	// any ballast has smaller or equal random address?
  if (aResult) {
  	// yes, there is at least one, max address is what we searched so far
    searchMax = searchAddr;
  }
  else {
  	// none at or below current search
    if (searchMin==0xFFFFFF) {
    	// already at max possible -> no devices found
      [self displayAndEndAddressAssignWithSuccess:NO];
      return;
    }
    searchMin = searchAddr+1; // new min
  }
  if (searchMin==searchMax && searchAddr==searchMin) {
    // found!
		NSLog(@">>> Lowest random address is 0x%lX (searchMin=0x%lX, searchMax=0x%lX)", searchAddr, searchMin, searchMax);
    // program new address here
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xB7 dali2:(newAddress<<1)+1 duration:1];
    // withdraw it from further searches
    [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xAB dali2:0 duration:1];
    // Verify new address and display result
    noAnswerReps = 0;
		[self verifyNewShortAddr];
  }
	else {
  	// not yet - continue
	  searchAddr = searchMin + (searchMax-searchMin)/2;
		NSLog(@"                                      new searchMin=0x%lX, searchMax=0x%lX", searchMin, searchMax);
    // issue next compare
    [self performSelector:@selector(nextCompare) withObject:nil afterDelay:0.001];
    return;
  }
}


@end

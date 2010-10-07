//
//  MainViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "MainViewController.h"

#import "MixLightsAppDelegate.h"
#import "DALIcomm.h"

@implementation MainViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	// flip side not yet loaded
  flipSideViewController = nil;
	// init defaults
  [[NSUserDefaults standardUserDefaults] registerDefaults:
  	[NSDictionary dictionaryWithObjectsAndKeys:
    	[NSNumber numberWithInt:0], @"addrGroup", // all lamps
    	[NSNumber numberWithInt:0], @"addrDigit", // first digit
    	nil
    ]
  ];
	// get segment controls from defaults
	addrGroupSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrGroup"];
	addrDigitSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrDigit"];
	[super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender
{ 
	if (!flipSideViewController) {   	
		flipSideViewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
		flipSideViewController.delegate = self;
  }
	
	flipSideViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:flipSideViewController animated:YES];	
}


- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
  [flipSideViewController release]; flipSideViewController=nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc
{
  [flipSideViewController release];
  [super dealloc];
}



- (uint8_t)daliAddr
{
	int group = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrGroup"];
	int digit = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrDigit"];
  if (group==0) {
  	// broadcast to all
    return 0xFE;
  }
  else if (group==3) {
  	// group address
    return 0x80+(digit<<1);
  }
  else {
  	// single lamp address
    return ((group-1)*10+digit) << 1;
  }
}



- (IBAction)addrGroupChanged:(UISegmentedControl *)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"addrGroup"];
}


- (IBAction)addrDigitChanged:(UISegmentedControl *)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"addrDigit"];
}




- (IBAction)lightOn:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr] dali2:254];
}


- (IBAction)lightOff:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr] dali2:0];
}



- (IBAction)lightDimmer:(UISlider *)sender
{
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  if ([daliComm isReady]) {
		[daliComm daliSend:[self daliAddr] dali2:[sender value]*254];
  }
}


- (IBAction)sceneChanged:(UISegmentedControl *)sender
{
	// goto scene (for all ballasts)
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xFF dali2:0x10+sender.selectedSegmentIndex];
}


- (IBAction)addToScene:(UIButton *)sender
{
	// add addressed ballasts to scene
  // - get current arc power level into DTR
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr]+1 dali2:0x21];
  // - save it in the scene
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr]+1 dali2:0x40+sceneSegControl.selectedSegmentIndex];
}


- (IBAction)removeFromScene:(UIButton *)sender
{
	// remove addressed ballasts from scene
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr]+1 dali2:0x50+sceneSegControl.selectedSegmentIndex];
}



- (IBAction)resetBridge:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm sendDaliBridgeCommand:0 dali1:0 dali2:0 expectsAnswer:NO answerTarget:nil selector:nil timeout:1];
}






@end

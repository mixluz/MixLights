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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
  	return YES; // iPad: all supported
  }
  else {
  	return (interfaceOrientation == UIInterfaceOrientationPortrait); // iPhone: only portrait
  }
}


- (void)dealloc
{
  [flipSideViewController release];
  [super dealloc];
}


#define LOGARITHMIC_LIGHT

int sliderToArcpower(double aSlider)
{
	#ifdef LOGARITHMIC_LIGHT
  return log10((aSlider*9)+1)*254; // logarithmic
  #else
	return aSlider*254; // simple linear
  #endif
}


double arcpowerToSlider(int aArcpower)
{
	#ifdef LOGARITHMIC_LIGHT
  return (pow(10, aArcpower/254.0)-1)/9; // logarithmic
  #else
	return ((double)aArcPower)/254; // simple linear
  #endif
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


- (void)getLightLevel
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:[self daliAddr]+1 dali2:0xA0 answerTarget:self selector:@selector(lightLevelAnswer:)];
}


- (void)lightLevelAnswer:(NSNumber *)aLightLevel
{
	if (aLightLevel) {
		[dimmerSlider setValue:arcpowerToSlider([aLightLevel intValue]) animated:YES];
  }
}



- (IBAction)addrGroupChanged:(UISegmentedControl *)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"addrGroup"];
  [self getLightLevel];
}


- (IBAction)addrDigitChanged:(UISegmentedControl *)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"addrDigit"];
  [self getLightLevel];
}




- (IBAction)lightOn:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr] dali2:254];
  [dimmerSlider setValue:1 animated:YES];
}


- (IBAction)lightOff:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[self daliAddr] dali2:0];
  [dimmerSlider setValue:0 animated:YES];
}



- (IBAction)lightDimmer:(UISlider *)sender
{
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  if ([daliComm isReady]) {
		[daliComm daliSend:[self daliAddr] dali2:sliderToArcpower([sender value])];
  }
}


- (IBAction)sceneChanged:(UISegmentedControl *)sender
{
	// goto scene (for all ballasts)
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xFF dali2:0x10+sender.selectedSegmentIndex];
  [self getLightLevel];
}


- (IBAction)addToScene:(UIButton *)sender
{
	// add addressed ballasts to scene
  // - get current arc power level into DTR
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:[self daliAddr]+1 dali2:0x21];
  // - save it in the scene
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:[self daliAddr]+1 dali2:0x40+sceneSegControl.selectedSegmentIndex];
}


- (IBAction)removeFromScene:(UIButton *)sender
{
	// remove addressed ballasts from scene
  [[MixLightsAppDelegate sharedAppDelegate].daliComm daliDoubleSend:[self daliAddr]+1 dali2:0x50+sceneSegControl.selectedSegmentIndex];
}



- (IBAction)resetBridge:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm sendDaliBridgeCommand:0 dali1:0 dali2:0 expectsAnswer:NO answerTarget:nil selector:nil timeout:1];
}






@end

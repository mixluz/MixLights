//
//  TechnoViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "TechnoViewController.h"

#import "MixLightsAppDelegate.h"
#import "DALIcomm.h"

@implementation TechnoViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	// flip side not yet loaded
  hackerViewController = nil;
	// init defaults
  [[NSUserDefaults standardUserDefaults] registerDefaults:
  	[NSDictionary dictionaryWithObjectsAndKeys:
    	[NSNumber numberWithInt:0], @"addrGroup", // all lamps
    	[NSNumber numberWithInt:0], @"addrDigit", // first digit
    	[NSNumber numberWithInt:0], @"defScene", // default scene
    	nil
    ]
  ];
	// get segment controls from defaults
	addrGroupSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrGroup"];
	addrDigitSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrDigit"];
	sceneSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"defScene"];
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
	// set IP (which might have changed on flipside)
  [[MixLightsAppDelegate sharedAppDelegate].daliComm setConnectionHost:[[NSUserDefaults standardUserDefaults] stringForKey:@"DaliBridgeIP"] port:2101]; // port = TCP raw access
	// get current light level
	[self getLightLevel];  
	// done
	[super viewDidAppear:animated];
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
  [hackerViewController release]; hackerViewController=nil;
}


- (void)dealloc
{
  [HackerViewController release];
  [super dealloc];
}



#pragma mark Flipside view


- (void)HackerViewControllerDidFinish:(HackerViewController *)controller
{    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender
{ 
	if (!hackerViewController) {   	
		hackerViewController = [[HackerViewController alloc] initWithNibName:@"HackerView" bundle:nil];
		hackerViewController.delegate = self;
  }
	
	hackerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:hackerViewController animated:YES];	
}



#pragma mark MixLight controlling


- (int)lampAddr
{
	int group = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrGroup"];
	int digit = [[NSUserDefaults standardUserDefaults] integerForKey:@"addrDigit"];
  if (group==0) {
  	// broadcast to all
    return LAMPBROADCAST;
  }
  else if (group==3) {
  	// group address
    return LAMPGROUP(digit);
  }
  else {
  	// single lamp address
    return (group-1)*10+digit;
  }
}


- (uint8_t)daliAddr
{
	return [DALIcomm daliAddressForLamp:[self lampAddr]];
}



- (void)updateConnectionStatus
{
	titleLabel.textColor = [[MixLightsAppDelegate sharedAppDelegate].daliComm isConnectable] ? [UIColor yellowColor] : [UIColor redColor];
}



- (void)getLightLevel
{
	[self updateConnectionStatus];
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliQuerySend:[self daliAddr]+1 dali2:0xA0 answerTarget:self selector:@selector(lightLevelAnswer:)];
}


- (void)lightLevelAnswer:(NSNumber *)aLightLevel
{
	if (aLightLevel) {
		[dimmerSlider setValue:arcpowerToDimmer([aLightLevel intValue]) animated:YES];
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
		[daliComm setLamp:[self lampAddr] dimmerValue:[sender value] keepOn:YES];
  }
}


- (IBAction)sceneChanged:(UISegmentedControl *)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:sceneSegControl.selectedSegmentIndex forKey:@"defScene"];
}


- (IBAction)loadScene:(UIButton *)sender
{
	// goto scene (for all ballasts)
	[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:0xFF dali2:0x10+sceneSegControl.selectedSegmentIndex];
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


@end

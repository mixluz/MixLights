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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender
{    	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
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
  [super dealloc];
}


- (IBAction)lightSwitch:(UISwitch *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm sendDaliBridgeCommand:16 dali1:0xFE dali2:[sender isOn] ? 254 : 0];
}


- (IBAction)lightDimmer:(UISlider *)sender
{
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  if ([daliComm isReady]) {
		[daliComm sendDaliBridgeCommand:16 dali1:0xFE dali2:[sender value]*254];
  }
}


- (IBAction)resetBridge:(UIButton *)sender
{
	[[MixLightsAppDelegate sharedAppDelegate].daliComm sendDaliBridgeCommand:0 dali1:0 dali2:0];
}




@end

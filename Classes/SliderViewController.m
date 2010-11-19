//
//  SliderViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/11/19.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "SliderViewController.h"

#import "MixLightsAppDelegate.h"
#import "DALIcomm.h"

@implementation SliderViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
	// set IP (which might have changed on flipside)
  [[MixLightsAppDelegate sharedAppDelegate].daliComm setConnectionHost:[[NSUserDefaults standardUserDefaults] stringForKey:@"DaliBridgeIP"] port:2101]; // port = TCP raw access
	//%%% later: maybe get current light level of all lamps
	// done
	[super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
}


- (void)dealloc
{
  [super dealloc];
}


#pragma mark MixLight controls


- (UIView *)getSubViewOfClass:(Class)aClass withTag:(int)aTag
{
	for (UIView *v in self.view.subviews) {
  	if (v.tag==aTag && [v isKindOfClass:aClass]) {
    	return v;
    }
  }
  return nil;
}



- (IBAction)lightToggle:(UIButton *)sender
{
	if (sender.selected) {
  	// turn off light
		[[MixLightsAppDelegate sharedAppDelegate].daliComm daliSend:[DALIcomm daliAddressForLamp:sender.tag] dali2:0];
  }
  else {
  	// turn on light with brigthness of slider
    UISlider *mySlider = (UISlider *)[self getSubViewOfClass:[UISlider class] withTag:sender.tag];
		[[MixLightsAppDelegate sharedAppDelegate].daliComm setLamp:sender.tag dimmerValue:[mySlider value] keepOn:YES];
  }
  sender.selected = !sender.selected;
}



- (IBAction)lightDimmer:(UISlider *)sender
{
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  if ([daliComm isReady]) {
		[daliComm setLamp:sender.tag dimmerValue:[sender value] keepOn:YES];
    // make sure light button is selected again
    UIButton *myButton = (ZButton *)[self getSubViewOfClass:[UIButton class] withTag:sender.tag];
    myButton.selected = YES;
  }
}


@end

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


#define NUM_LAMPS_IN_LINE 6
#define FIRST_LAMP_IN_LINE 10


@interface SliderViewController ()
{
  double lastVal;
  double intensities[NUM_LAMPS_IN_LINE];
  BOOL intensitiesValid;
  double currentTranslation;
}

@end


@implementation SliderViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
  intensitiesValid = NO;
  // make sliders of lamps 10-15 vertical
  for (UIView *v in self.view.subviews) {
  	if (v.tag>=10 && v.tag<=15 && [v isKindOfClass:[UISlider class]]) {
      v.transform = CGAffineTransformRotate(v.transform,270.0/180*M_PI);
//      v.autoresizingMask = UIViewAutoresizingFlexibleRightMargin+UIViewAutoresizingFlexibleHeight;
    }
  }
}


- (void)viewDidAppear:(BOOL)animated
{
	// (re)set IP (which might have changed on flipside)
  [[MixLightsAppDelegate sharedAppDelegate] initDaliComm];
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
  [self setSweepSlider:nil];
}


- (void)dealloc
{
  [_sweepSlider release];
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


- (void)moveLightBy:(double)aTranslation
{
  double newintensities[NUM_LAMPS_IN_LINE];
  // calculate new intensities for each lamp
  for (int i=0; i<NUM_LAMPS_IN_LINE; i++) {
    double samplePos = i-aTranslation*NUM_LAMPS_IN_LINE;
    // - always positive (within 0..1)
    if (samplePos<0) samplePos+=NUM_LAMPS_IN_LINE;
    else if (samplePos>=NUM_LAMPS_IN_LINE) samplePos-=NUM_LAMPS_IN_LINE;
    int firstLamp = trunc(samplePos);
    int secondLamp = firstLamp<NUM_LAMPS_IN_LINE-1 ? firstLamp+1 : 0;
    double fractionOfSecond = samplePos-firstLamp;
    newintensities[i] =
      intensities[firstLamp]*(1-fractionOfSecond) +
      intensities[secondLamp]*(fractionOfSecond);
  }
  // set new intensities
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  for (int i=0; i<NUM_LAMPS_IN_LINE; i++) {
    [((UISlider *)[self getSubViewOfClass:[UISlider class] withTag:FIRST_LAMP_IN_LINE+i]) setValue:newintensities[i] animated:NO];
    if ([daliComm isReady]) {
      [daliComm setLamp:FIRST_LAMP_IN_LINE+i dimmerValue:newintensities[i] keepOn:YES];
    }
  }
}


- (IBAction)sweepChanged:(id)sender
{
  if (!intensitiesValid) {
    // sample current slider values
    for (int i=0; i<NUM_LAMPS_IN_LINE; i++) {
      intensities[i] = ((UISlider *)[self getSubViewOfClass:[UISlider class] withTag:FIRST_LAMP_IN_LINE+i]).value;
      // using sweeper turns on all lights
      ((ZButton *)[self getSubViewOfClass:[UIButton class] withTag:FIRST_LAMP_IN_LINE+i]).selected = YES;
    }
    intensitiesValid = YES;
    currentTranslation = 0;
  }
  double val = ((UISlider *)sender).value;
  if (lastVal<0) {
    lastVal = val;
  }
  else {
    double diff = val - lastVal;
    if (fabs(diff)>1.0/111) {
      // actually apply
      lastVal = val;
      // change translation
      currentTranslation+=diff*3;
      while (currentTranslation>=1) currentTranslation--;
      while (currentTranslation<0) currentTranslation++;
      [self moveLightBy:currentTranslation];
    }
  }
}

- (IBAction)sweepTouchUp:(id)sender
{
  // back to middle
  lastVal = 0.5;
  [self.sweepSlider setValue:0.5 animated:YES];
}


- (IBAction)lightToggle:(UIButton *)sender
{
  intensitiesValid = NO;
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
  intensitiesValid = NO;
	DALIcomm *daliComm = [MixLightsAppDelegate sharedAppDelegate].daliComm;
  if ([daliComm isReady]) {
		[daliComm setLamp:sender.tag dimmerValue:[sender value] keepOn:YES];
    // make sure light button is selected again
    UIButton *myButton = (ZButton *)[self getSubViewOfClass:[UIButton class] withTag:sender.tag];
    myButton.selected = YES;
  }
}


@end

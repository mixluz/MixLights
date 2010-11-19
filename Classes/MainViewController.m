    //
//  MainViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/11/19.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

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


@end

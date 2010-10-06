//
//  MainViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
	IBOutlet UISegmentedControl *addrGroupSegControl;
	IBOutlet UISegmentedControl *addrDigitSegControl;
  // vars
  FlipsideViewController *flipSideViewController;
}

// controls for light
- (IBAction)lightSwitch:(UISwitch *)sender;
- (IBAction)lightDimmer:(UISlider *)sender;
- (IBAction)resetBridge:(UIButton *)sender;
- (IBAction)addrGroupChanged:(UISegmentedControl *)sender;
- (IBAction)addrDigitChanged:(UISegmentedControl *)sender;

// call Flipside
- (IBAction)showInfo:(id)sender;


@end

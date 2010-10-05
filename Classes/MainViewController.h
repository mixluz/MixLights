//
//  MainViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
}

// controls for light
- (IBAction)lightSwitch:(UISwitch *)sender;
- (IBAction)lightDimmer:(UISlider *)sender;
- (IBAction)resetBridge:(UIButton *)sender;

// call Flipside
- (IBAction)showInfo:(id)sender;


@end

//
//  MainViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
	IBOutlet UISegmentedControl *addrGroupSegControl;
	IBOutlet UISegmentedControl *addrDigitSegControl;
	IBOutlet UISegmentedControl *sceneSegControl;
  IBOutlet UISlider *dimmerSlider;
  // vars
  FlipsideViewController *flipSideViewController;
}

// controls for light
- (IBAction)lightOn:(UIButton *)sender;
- (IBAction)lightOff:(UIButton *)sender;
- (IBAction)lightDimmer:(UISlider *)sender;
- (IBAction)resetBridge:(UIButton *)sender;
- (IBAction)addrGroupChanged:(UISegmentedControl *)sender;
- (IBAction)addrDigitChanged:(UISegmentedControl *)sender;
- (IBAction)sceneChanged:(UISegmentedControl *)sender;
- (IBAction)addToScene:(UIButton *)sender;
- (IBAction)removeFromScene:(UIButton *)sender;

// call Flipside
- (IBAction)showInfo:(id)sender;


@end

//
//  SliderViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/11/19.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZButton.h"


@interface SliderViewController : UIViewController {

}
@property (retain, nonatomic) IBOutlet UISlider *sweepSlider;

- (IBAction)sweepChanged:(id)sender;
- (IBAction)sweepTouchUp:(id)sender;

- (IBAction)lightToggle:(ZButton *)sender;
- (IBAction)lightDimmer:(UISlider *)sender;

@end

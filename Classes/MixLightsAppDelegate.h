//
//  MixLightsAppDelegate.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DALIcomm.h"

@class TechnoViewController;

@interface MixLightsAppDelegate : NSObject <UIApplicationDelegate>
{
  UIWindow *window;
  TechnoViewController *TechnoViewController;
  // DALI communicator
  DALIcomm *daliComm;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TechnoViewController *technoViewController;
@property (readonly) DALIcomm *daliComm;

+ (MixLightsAppDelegate *)sharedAppDelegate;

@end


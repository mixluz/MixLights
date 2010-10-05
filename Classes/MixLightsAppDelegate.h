//
//  MixLightsAppDelegate.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DALIcomm.h"

@class MainViewController;

@interface MixLightsAppDelegate : NSObject <UIApplicationDelegate>
{
  UIWindow *window;
  MainViewController *mainViewController;
  // DALI communicator
  DALIcomm *daliComm;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (readonly) DALIcomm *daliComm;

+ (MixLightsAppDelegate *)sharedAppDelegate;

@end


//
//  UIAlertView+ZUtils.h
//
//  Created by Lukas Zeller on 29.06.12.
//  Copyright (c) 2012 plan44.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZAlertViewWhenDismissedHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (ZUtils)

@property (copy) ZAlertViewWhenDismissedHandler whenDismissedHandler;

+ (UIAlertView *)alertViewWithTitle:(NSString *)aTitle
  message:(NSString *)aMessage
  whenDismissed:(ZAlertViewWhenDismissedHandler)aWhenDismissedBlock;

- (UIAlertView *)initWithTitle:(NSString *)aTitle
  message:(NSString *)aMessage
  whenDismissed:(ZAlertViewWhenDismissedHandler)aWhenDismissedBlock;

@end

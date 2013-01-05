//
//  UIAlertView+ZUtils.m
//
//  Created by Lukas Zeller on 29.06.12.
//  Copyright (c) 2012 plan44.ch. All rights reserved.
//

#import "UIAlertView+ZUtils.h"

#import <objc/runtime.h>


@implementation UIAlertView (ZUtils)

@dynamic whenDismissedHandler;

static char DISMISSHANDLER_IDENTIFER; // Note: the identifier is the address of that variable (unique per process!)

- (void)setWhenDismissedHandler:(ZAlertViewWhenDismissedHandler)aWhenDismissedHandler
{
  objc_setAssociatedObject(self, &DISMISSHANDLER_IDENTIFER, aWhenDismissedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZAlertViewWhenDismissedHandler)whenDismissedHandler
{
  return objc_getAssociatedObject(self, &DISMISSHANDLER_IDENTIFER);
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  self.whenDismissedHandler(alertView, buttonIndex);
}


+ (UIAlertView *)alertViewWithTitle:(NSString *)aTitle
  message:(NSString *)aMessage
  whenDismissed:(ZAlertViewWhenDismissedHandler)aWhenDismissedBlock
{
  return [[UIAlertView alloc] initWithTitle:aTitle message:aMessage whenDismissed:aWhenDismissedBlock];
}


- (UIAlertView *)initWithTitle:(NSString *)aTitle
  message:(NSString *)aMessage
  whenDismissed:(ZAlertViewWhenDismissedHandler)aWhenDismissedBlock
{
  if ((self = [super init])) {
    self.title = aTitle;
    self.message = aMessage;
    self.delegate = (id<UIAlertViewDelegate>)self;
    self.whenDismissedHandler = aWhenDismissedBlock;
  }
  return self;
}

@end

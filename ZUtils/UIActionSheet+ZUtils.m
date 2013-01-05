//
//  UIActionSheet+ZUtils.m
//
//  Created by Lukas Zeller on 29.06.12.
//  Copyright (c) 2012 plan44.ch. All rights reserved.
//

#import "UIActionSheet+ZUtils.h"

#import <objc/runtime.h>

@implementation UIActionSheet (ZUtils)

@dynamic whenDismissedHandler;


static char DISMISSHANDLER_IDENTIFER; // Note: the identifier is the address of that variable (unique per process!)

- (void)setWhenDismissedHandler:(ZActionSheetWhenDismissedHandler)aWhenDismissedHandler
{
  objc_setAssociatedObject(self, &DISMISSHANDLER_IDENTIFER, aWhenDismissedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZActionSheetWhenDismissedHandler)whenDismissedHandler
{
  return objc_getAssociatedObject(self, &DISMISSHANDLER_IDENTIFER);
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  self.whenDismissedHandler(actionSheet, buttonIndex);
}


+ (UIActionSheet *)actionSheetWithTitle:(NSString *)aTitle
  whenDismissed:(ZActionSheetWhenDismissedHandler)aWhenDismissedBlock
{
  return [[UIActionSheet alloc] initWithTitle:aTitle whenDismissed:aWhenDismissedBlock];
}


- (UIActionSheet *)initWithTitle:(NSString *)aTitle
  whenDismissed:(ZActionSheetWhenDismissedHandler)aWhenDismissedBlock
{
  if ((self = [super init])) {
    self.title = aTitle;
    self.delegate = (id<UIActionSheetDelegate>)self;
    self.whenDismissedHandler = aWhenDismissedBlock;
  }
  return self;
}


@end

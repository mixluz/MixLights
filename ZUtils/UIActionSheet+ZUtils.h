//
//  UIActionSheet+ZUtils.h
//
//  Created by Lukas Zeller on 29.06.12.
//  Copyright (c) 2012 plan44.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZActionSheetWhenDismissedHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (ZUtils)

@property (copy) ZActionSheetWhenDismissedHandler whenDismissedHandler;

+ (UIActionSheet *)actionSheetWithTitle:(NSString *)aTitle
  whenDismissed:(ZActionSheetWhenDismissedHandler)aWhenDismissedBlock;

- (UIActionSheet *)initWithTitle:(NSString *)aTitle
  whenDismissed:(ZActionSheetWhenDismissedHandler)aWhenDismissedBlock;

@end

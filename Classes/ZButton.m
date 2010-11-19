//
//  ZButton.m
//  AppZwerg
//
//  Created by Lukas Zeller on 2010/03/12.
//  Copyright 2010 Lukas Zeller. All rights reserved.
//

#import "ZButton.h"


@implementation ZButton


- (void)internalInit
{
	// assume half circle ends: set image cap accordingly
  [self setBackgroundImage:
  	[[self backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:self.frame.size.height/2-1 topCapHeight:0]
    forState:UIControlStateNormal
  ];
}


- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self internalInit];
  }
  return self;
}


- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
    [self internalInit];
	}
	return self;
}



/*
- (void)drawRect:(CGRect)rect
{
  // Drawing code
}
*/


- (void)dealloc
{
  [super dealloc];
}


@end

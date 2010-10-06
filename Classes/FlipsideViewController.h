//
//  FlipsideViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
  // controls
  IBOutlet UITextField *bridgeCmdField;
  IBOutlet UITextField *daliCmdField;
  IBOutlet UITextField *daliAnswerField;
  IBOutlet UITextField *dtrValueField;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)sendCommand:(id)sender;
- (IBAction)sendDTRAndCommand:(id)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end


//
//  FlipsideViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
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
  IBOutlet UIActivityIndicatorView *progressSpinner;
  // vars
  unsigned newAddress;
  BOOL assignInProgress;
  uint32_t searchMin, searchMax;
	uint32_t searchAddr;
  uint8_t searchH, searchM, searchL;
  int noAnswerReps;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)sendCommand:(id)sender;
- (IBAction)sendDTRAndCommand:(id)sender;
- (IBAction)assignAddressPhysical;
- (IBAction)assignAddressRandom;

- (IBAction)editDone:(UIResponder *)aResponder;

// private
- (void)verifyNewShortAddr;
- (void)verifyShortAddrAnswer:(NSNumber *)aAnswer;
- (void)nextCompare;
- (void)compareResult:(NSNumber *)aResult;
- (void)displayAndEndAddressAssignWithSuccess:(BOOL)aSuccess;


@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end


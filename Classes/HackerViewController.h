//
//  HackerViewController.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HackerViewControllerDelegate;


@interface HackerViewController : UIViewController {
	id <HackerViewControllerDelegate> delegate;
  // controls
  IBOutlet UITextField *bridgeCmdField;
  IBOutlet UITextField *daliCmdField;
  IBOutlet UITextField *daliAnswerField;
  IBOutlet UITextField *dtrValueField;
  IBOutlet UIActivityIndicatorView *progressSpinner;
  IBOutlet UITextField *daliBridgeAddrField;
  IBOutlet UISwitch *alsoWithShortAddrSwitch;
  IBOutlet UISwitch *tunnelSwitch;
  // vars
  unsigned newAddress;
  BOOL assignInProgress;
  BOOL searchInProgress;
  uint32_t searchMin, searchMax;
	uint32_t searchAddr;
  uint8_t searchH, searchM, searchL;
  int noAnswerReps;
}
@property (nonatomic, assign) id <HackerViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)sendCommand:(id)sender;
- (IBAction)sendDTRAndCommand:(id)sender;
- (IBAction)assignAddressPhysical;
- (IBAction)assignAddressRandom;
- (IBAction)findNextAdressableBallast;

- (IBAction)editDone:(UIResponder *)aResponder;

// private
- (void)startNewSearchUpwardsFrom:(uint32_t)aMinSearchAddr;
- (void)verifyNewShortAddr;
- (void)verifyShortAddrAnswer:(NSNumber *)aAnswer;
- (void)nextCompare;
- (void)compareResult:(NSNumber *)aResult;
- (void)displayAndEndAddressAssignWithSuccess:(BOOL)aSuccess;


@end


@protocol HackerViewControllerDelegate
- (void)HackerViewControllerDidFinish:(HackerViewController *)controller;
@end


//
//  FlipsideViewController.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "FlipsideViewController.h"

#import "MixLightsAppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


- (void)sendCommandAnswer:(NSNumber *)aAnswer
{
	if (aAnswer) {
  	daliAnswerField.text = [NSString stringWithFormat:@"%02X",[aAnswer intValue]];
  }
  else {
  	daliAnswerField.text = @"n/a";
  }
}


- (IBAction)sendCommand:(id)sender
{
	// scan hex values
  // - bridge command
	NSScanner *scanner = [NSScanner scannerWithString:bridgeCmdField.text];
	unsigned bridgeCmd;
  if (![scanner scanHexInt:&bridgeCmd]) return; // nop
  // - DALI command
	scanner = [NSScanner scannerWithString:daliCmdField.text];
	unsigned daliCmd;
  if (![scanner scanHexInt:&daliCmd]) return; // nop
  // values ok, update texts
  bridgeCmdField.text = [NSString stringWithFormat:@"%02X",bridgeCmd];
  daliCmdField.text = [NSString stringWithFormat:@"%04X",daliCmd];
  // send
	[[MixLightsAppDelegate sharedAppDelegate].daliComm
  	sendDaliBridgeCommand:bridgeCmd dali1:(daliCmd>>8)&0xFF dali2:daliCmd&0xFF
    expectsAnswer:YES answerTarget:self selector:@selector(sendCommandAnswer:)
    timeout:1.0 // wait long enough
  ];
}


- (IBAction)sendDTRAndCommand:(id)sender
{
  // - DTR value
	unsigned dtr = [dtrValueField.text intValue];
  // send DTR
	[[MixLightsAppDelegate sharedAppDelegate].daliComm
		daliSend:0xA3 dali2:dtr
  ];
  // now send command itself
  [self sendCommand:sender];
}




@end

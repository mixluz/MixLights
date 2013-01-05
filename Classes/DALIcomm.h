//
//  DALIcomm.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import "Reachability.h"

@interface DALIcmdBlock : NSObject
{
  uint8_t bridgeCmd;
  uint8_t dali1;
  uint8_t dali2;
  // properties
  BOOL expectsResponse;
  id resultTarget;
  SEL resultSelector;
  NSTimeInterval minTimeToNextCmd; 
}
@property(assign) uint8_t bridgeCmd;
@property(assign) uint8_t dali1;
@property(assign) uint8_t dali2;
@property(assign) BOOL expectsResponse;
@property(retain) id resultTarget;
@property(assign) SEL resultSelector;
@property(assign) NSTimeInterval minTimeToNextCmd;


- (id)initWithBridgeCmd:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2;

@end



int dimmerToArcpower(double aSlider);
double arcpowerToDimmer(int aArcpower);

#define LAMP_GROUP_OFFSET 100
#define LAMPGROUP(x) (x|LAMP_GROUP_OFFSET)
#define LAMPBROADCAST 999

@interface DALIcomm : NSObject <NSStreamDelegate>
{
	// reachability
  Reachability *reachability;
  
	// host and port
  NSString *host;
  NSInteger port;
	// the streams
  NSInputStream *readStream;
  NSOutputStream *writeStream;
  // send pacing
  NSTimeInterval nextCmdPossible;
  // sending queue
  NSMutableArray *sendQueue;
  // next command waiting for response
  DALIcmdBlock *responseWaitCmd;
  // connection timeout
  NSTimeInterval connectionLastUsed;
  BOOL connectionCheckerActive;  
}
- (void)setConnectionHost:(NSString *)aHost port:(NSInteger)aPort;
- (BOOL)openConnection;
- (void)closeConnection;
- (void)checkSend;
- (BOOL)isReady;
- (int)queueSize;
- (BOOL)isConnectable;


// direct DALI bridge commands
- (void)sendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2 expectsAnswer:(BOOL)aExpectsAnswer answerTarget:(id)aTarget selector:(SEL)aSelector timeout:(NSTimeInterval)aMinTimeToNextCmd;
// direct DALI commands
- (void)daliSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 duration:(NSTimeInterval)aMinTimeToNextCmd;
- (void)daliSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2;
- (void)daliDoubleSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 duration:(NSTimeInterval)aMinTimeToNextCmd;
- (void)daliDoubleSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2;
- (void)daliQuerySend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 answerTarget:(id)aTarget selector:(SEL)aSelector timeout:(NSTimeInterval)aTimeout;
- (void)daliQuerySend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 answerTarget:(id)aTarget selector:(SEL)aSelector;
// abstracted
+ (uint8_t)daliAddressForLamp:(int)aLampAddr;
- (void)setLamp:(int)aLampAddr dimmerValue:(double)aDimmerValue keepOn:(BOOL)aKeepOn;

@end

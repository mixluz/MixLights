//
//  DALIcomm.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "DALIcomm.h"


@implementation DALIcmdBlock

@synthesize bridgeCmd;
@synthesize dali1;
@synthesize dali2;
@synthesize expectsResponse;
@synthesize resultTarget;
@synthesize resultSelector;
@synthesize minTimeToNextCmd;



#define DEFAULT_MIN_TIME_BETWEEN_CMDS 0.100 // default to 100ms between commands min

#define ACK_WAIT_TIME 1.0 // time to wait for commands for which we expect an ACK

- (id)initWithBridgeCmd:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	if (self = [super init]) {
    // save
    bridgeCmd = aCmd;
    dali1 = aDali1;
    dali2 = aDali2;
    // other init
    expectsResponse = NO;
    minTimeToNextCmd = DEFAULT_MIN_TIME_BETWEEN_CMDS;
    resultTarget = nil;
    resultSelector = nil;
  }
  return self;
}



- (void)dealloc
{
  [resultTarget release];
  [super dealloc];
}


@end // DALIcmdBlock




@implementation DALIcomm




- (id)init
{
	if (self=[super init]) {
  	readStream = nil;
    writeStream = nil;
    host = nil;
    port = 0;
    nextCmdPossible = 0;
    sendQueue = [[NSMutableArray alloc] init];
    responseWaitCmd = nil;
  }
  return self;
}


- (void)dealloc
{
	[self closeConnection];
  [host release];
  [sendQueue release];
  [responseWaitCmd release];
	[super dealloc];
}


- (void)setConnectionHost:(NSString *)aHost port:(NSInteger)aPort
{
	[host release];
  host = [aHost retain];
  port = aPort;
}


- (void)openConnection
{
	// close previous connection
	[self closeConnection];
  // create stream pair to remote socket
  CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)host, port, (CFReadStreamRef *)&readStream, (CFWriteStreamRef *)&writeStream);
	// set delegate
  [readStream setDelegate:self];
  [writeStream setDelegate:self];
	// schedule in run loop
  [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  // open both
  [readStream open];
  [writeStream open];
}



- (void)closeConnection
{
	if (readStream) {
  	[readStream close];
    [readStream release];
    readStream = nil;
  }
	if (writeStream) {
  	[writeStream close];
    [writeStream release];
    writeStream = nil;
  }
}


// stream delegate
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
  //NSLog(@"stream:handleEvent: invoked with eventCode=%d",eventCode);
 
  switch(eventCode) {
    case NSStreamEventErrorOccurred: {
    	NSLog(@"Stream error:%@", [stream streamError]);
    }
    case NSStreamEventHasSpaceAvailable: {
    	if (stream==writeStream) {
        // space for sending got available, check if there is stuff to send
        [self checkSend];
      }
    }
    case NSStreamEventHasBytesAvailable: {
    	if (stream==readStream) {
			  NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
        // got a response
        uint8_t rdbuf = 0xDD;
        if ([readStream read:&rdbuf maxLength:1]>0) {
          if (responseWaitCmd) {
            // a command is waiting for the response, dispatch it
            DALIcmdBlock *rwc = responseWaitCmd;
            responseWaitCmd = nil; // no longer waiting, in case callback wants to send more data          
            NSLog(@"[%f] received answer byte: 0x%02X (for command 0x%02X,0x%02X,0x%02X)", now, rdbuf, rwc.bridgeCmd,rwc.dali1,rwc.dali2);
            if (rwc.resultTarget && [rwc.resultTarget respondsToSelector:rwc.resultSelector]) {
              // report the answer
              [rwc.resultTarget performSelector:rwc.resultSelector withObject:[NSNumber numberWithInt:rdbuf]];
            }
            if (rwc.expectsResponse) {
              // expects response (but might not have a callback, if the response is only an ack to keep correct pacing)
              nextCmdPossible = now; // next command can take place from now on	
              [self performSelector:@selector(checkSend)]; // immediately check if there is a next command that needs sending
            }          
            // forget this response wait command
            [rwc release];           
          }
          else {
            // just forget
            NSLog(@"[%f] received excess byte nobody was expecting: 0x%02X", now, rdbuf);
          }
        }
      }
    }
    break;
	}    
}


- (BOOL)isReady
{
	return [sendQueue count]==0 && !responseWaitCmd;
}



- (void)checkSend
{
  NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
  // previous command over, if someone was waiting for an answer to it, report no answer now
  if (now>nextCmdPossible && responseWaitCmd) {
    NSLog(@"[%f] answer wait timed out for command 0x%02X,0x%02X,0x%02X",now,responseWaitCmd.bridgeCmd,responseWaitCmd.dali1,responseWaitCmd.dali2);
  	if (responseWaitCmd.resultTarget && [responseWaitCmd.resultTarget respondsToSelector:responseWaitCmd.resultSelector]) {
    	// report no answer
    	[responseWaitCmd.resultTarget performSelector:responseWaitCmd.resultSelector withObject:nil];
    }
    // forget this response wait command
    [responseWaitCmd release]; responseWaitCmd = nil;
  }
  // now check for sending next command
	if ([sendQueue count]>0) {
  	// some cmds are waiting in the queue
    // - check if possible to send from timing
    if (now<nextCmdPossible) {
    	// need to wait - schedule a check for later
      [self performSelector:@selector(checkSend) withObject:nil afterDelay:nextCmdPossible-now];
    }
    else if ([writeStream hasSpaceAvailable]) {
    	// time to send, and write stream available
      // - extract command from queue
      DALIcmdBlock *cmd = [[sendQueue objectAtIndex:0] retain];
      // - delete from queue
      [sendQueue removeObjectAtIndex:0];
      // - keep it we need to wait for a response
      if (cmd.expectsResponse) {
      	responseWaitCmd = [cmd retain];
      }
      // - actually send
      uint8_t bridgeCmd[3];
      bridgeCmd[0] = cmd.bridgeCmd;
      bridgeCmd[1] = cmd.dali1;
      bridgeCmd[2] = cmd.dali2;
      if ([writeStream write:bridgeCmd maxLength:3]!=3) {
      	NSLog(@"could not send 3 command bytes");
      }
      else {
		    NSLog(@"[%f] sent command 0x%02X,0x%02X,0x%02X",now,cmd.bridgeCmd,cmd.dali1,cmd.dali2);
      }
      // - calculate when next command can be sent earliest
      nextCmdPossible = now+cmd.minTimeToNextCmd;
      // - schedule a check then (to see if more to send, and to time out wait for response)
      [self performSelector:@selector(checkSend) withObject:nil afterDelay:cmd.minTimeToNextCmd];
      // - done with this cmd
      [cmd release];
    }
  }
}




- (void)sendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2 expectsAnswer:(BOOL)aExpectsAnswer answerTarget:(id)aTarget selector:(SEL)aSelector timeout:(NSTimeInterval)aMinTimeToNextCmd
{
	// create command
  DALIcmdBlock *cmd = [[DALIcmdBlock alloc] initWithBridgeCmd:aCmd dali1:aDali1 dali2:aDali2];
  cmd.resultTarget = aTarget;
  cmd.resultSelector = aSelector;
  cmd.expectsResponse = aExpectsAnswer;
  cmd.minTimeToNextCmd = aMinTimeToNextCmd ? aMinTimeToNextCmd : DEFAULT_MIN_TIME_BETWEEN_CMDS;
  // - determine waiting
  //%%% tdb, use default for now
  // put into queue
  [sendQueue addObject:cmd];
  [cmd release]; // now owned by queue only
  // check if we need to send from the queue
  [self checkSend];
}


- (void)daliSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	// simple send with Ack
	[self sendDaliBridgeCommand:0x30 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:nil selector:nil timeout:ACK_WAIT_TIME];	
}


- (void)daliDoubleSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	// double send with Ack
	[self sendDaliBridgeCommand:0x31 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:nil selector:nil timeout:ACK_WAIT_TIME];	
}


- (void)daliQuerySend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 answerTarget:(id)aTarget selector:(SEL)aSelector
{
	// send and wait for single byte answer
	[self sendDaliBridgeCommand:0x32 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:aTarget selector:aSelector timeout:ACK_WAIT_TIME];
}




@end // DALIcomm

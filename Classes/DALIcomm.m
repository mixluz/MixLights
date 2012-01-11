//
//  DALIcomm.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
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
#define MIN_WAIT_AFTER_ANSWER 0.050 // wait 50ms after receiving answer before sending next

#define ACK_WAIT_TIME 1.0 // time to wait for commands for which we expect an ACK

#define MAX_CONNECTION_IDLETIME 2.0 // how long connection remains open

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
    connectionLastUsed = 0;
    connectionCheckerActive = NO;
    reachability = nil;
  }
  return self;
}


- (void)dealloc
{
	[self closeConnection];
  [host release];
  [sendQueue release];
  [responseWaitCmd release];
  [reachability release];
	[super dealloc];
}


- (void)setConnectionHost:(NSString *)aHost port:(NSInteger)aPort
{
	[host release];
  host = [aHost retain];
  port = aPort;
  // monitor reachability for the host
  [reachability release];
	reachability = [[Reachability reachabilityWithHostName:host] retain];
  [reachability startNotifier];
}


- (BOOL)isConnectable
{
	return [reachability currentReachabilityStatus]==ReachableViaWiFi;
}


- (BOOL)openConnection
{
	// close previous connection
	[self closeConnection];
  // check reachability
  if (![self isConnectable]) {
  	// not reachable via WiFi
    return NO;
  }
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
  // open possible
  return YES;
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
    // don't keep queued commands accross re-connections
    [sendQueue removeAllObjects];
  }
}


- (void)checkConnection
{
	NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
	NSTimeInterval leftIdle = (connectionLastUsed+MAX_CONNECTION_IDLETIME)-now;
  // let timeout only if not waiting for a response or still having queued commands 
	if (leftIdle<=0 && !responseWaitCmd && [sendQueue count]==0) {
  	// close connection now
    NSLog(@"--- Closed connection after idle time");
    [self closeConnection];
    connectionCheckerActive = NO;
  }
  else {
  	// check later again, in case of something else pending in 0.5 sec
  	[self performSelector:@selector(checkConnection) withObject:nil afterDelay:leftIdle<0 ? 0.5 : leftIdle];
  }
}


- (void)needConnection
{
	if (!readStream || !writeStream) {
    NSLog(@"+++ needed to open connection");
  	[self openConnection];
  }
  connectionLastUsed = [[NSDate date] timeIntervalSinceReferenceDate];
  if (!connectionCheckerActive) {
    connectionCheckerActive = YES;
  	[self performSelector:@selector(checkConnection) withObject:nil afterDelay:MAX_CONNECTION_IDLETIME];
  }
}


// stream delegate
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
  //NSLog(@"stream:handleEvent: invoked with eventCode=%d",eventCode);
 
  switch(eventCode) {
    case NSStreamEventErrorOccurred: {
    	NSLog(@"Stream error:%@, closing connection", [stream streamError]);
      [self closeConnection];
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
              nextCmdPossible = now+MIN_WAIT_AFTER_ANSWER; // next command can take place from now on	
              [self performSelector:@selector(checkSend) withObject:nil afterDelay:MIN_WAIT_AFTER_ANSWER]; // immediately check if there is a next command that needs sending
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
    	[responseWaitCmd.resultTarget performSelector:responseWaitCmd.resultSelector withObject:nil afterDelay:0.001];
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
    else {
      // need connection
  		[self needConnection];
      // send now if write space available, otherwise event will re-trigger checkSend later
      if ([writeStream hasSpaceAvailable]) {
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
}




- (void)sendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2 expectsAnswer:(BOOL)aExpectsAnswer answerTarget:(id)aTarget selector:(SEL)aSelector timeout:(NSTimeInterval)aMinTimeToNextCmd
{
	// check connectability
  if (![self isConnectable]) return;
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


- (void)daliSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 duration:(NSTimeInterval)aMinTimeToNextCmd
{
	// simple send with Ack
	[self sendDaliBridgeCommand:0x30 dali1:aDali1 dali2:aDali2 expectsAnswer:NO answerTarget:nil selector:nil timeout:aMinTimeToNextCmd];	
}

- (void)daliSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	// simple send with Ack
	[self sendDaliBridgeCommand:0x30 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:nil selector:nil timeout:ACK_WAIT_TIME];	
}



- (void)daliDoubleSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 duration:(NSTimeInterval)aMinTimeToNextCmd
{
	// double send with Ack
	[self sendDaliBridgeCommand:0x31 dali1:aDali1 dali2:aDali2 expectsAnswer:NO answerTarget:nil selector:nil timeout:aMinTimeToNextCmd];	
}

- (void)daliDoubleSend:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	// double send with Ack
	[self sendDaliBridgeCommand:0x31 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:nil selector:nil timeout:ACK_WAIT_TIME];	
}


- (void)daliQuerySend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 answerTarget:(id)aTarget selector:(SEL)aSelector timeout:(NSTimeInterval)aTimeout
{
	// send and wait for single byte answer
	[self sendDaliBridgeCommand:0x32 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:aTarget selector:aSelector timeout:aTimeout];
}


- (void)daliQuerySend:(uint8_t)aDali1 dali2:(uint8_t)aDali2 answerTarget:(id)aTarget selector:(SEL)aSelector
{
	// send and wait for single byte answer
	[self sendDaliBridgeCommand:0x32 dali1:aDali1 dali2:aDali2 expectsAnswer:YES answerTarget:aTarget selector:aSelector timeout:ACK_WAIT_TIME];
}


#pragma mark abstracted functionality


#define LOGARITHMIC_LIGHT

int dimmerToArcpower(double aSlider)
{
	if (aSlider<0) aSlider = 0;
	if (aSlider>1) aSlider = 1;
	#ifdef LOGARITHMIC_LIGHT
  return log10((aSlider*9)+1)*254; // logarithmic
  #else
	return aSlider*254; // simple linear
  #endif
}


double arcpowerToDimmer(int aArcpower)
{
	#ifdef LOGARITHMIC_LIGHT
  return (pow(10, aArcpower/254.0)-1)/9; // logarithmic
  #else
	return ((double)aArcPower)/254; // simple linear
  #endif
}


+ (uint8_t)daliAddressForLamp:(int)aLampAddr
{
	uint8_t daliAddr = 0;
	if (aLampAddr==LAMPBROADCAST) {
  	// broadcast
  	daliAddr = 0xFE;
  }
  else if (aLampAddr>=LAMP_GROUP_OFFSET) {
  	// group
    daliAddr = 0x80+((aLampAddr-LAMP_GROUP_OFFSET)<<1);
  }
  else {
  	// single lamp
    daliAddr = (aLampAddr)<<1;
  }
  return daliAddr;
}


- (void)setLamp:(int)aLampAddr dimmerValue:(double)aDimmerValue keepOn:(BOOL)aKeepOn
{
	uint8_t arcPower = dimmerToArcpower(aDimmerValue);
  if (aKeepOn && arcPower==0)
  	arcPower=1; // keep lamp on
  [self daliSend:[DALIcomm daliAddressForLamp:aLampAddr] dali2:arcPower];
}



@end // DALIcomm

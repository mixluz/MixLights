//
//  DALIcomm.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import "DALIcomm.h"


@implementation DALIcomm


#define MIN_TIME_BETWEEN_CMDS 0.050 // 50ms between commands min


- (id)init
{
	if (self=[super init]) {
  	readStream = nil;
    writeStream = nil;
    host = nil;
    port = 0;
    lastCommandOut = 0;
  }
  return self;
}


- (void)dealloc
{
	[self closeConnection];
  [host release];
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
  NSLog(@"stream:handleEvent: invoked with eventCode=%d",eventCode);
 
  switch(eventCode) {
    case NSStreamEventErrorOccurred: {
    	NSLog(@"Stream error:%@", [stream streamError]);
    }
    break;
	}    
}


- (BOOL)isReady
{
	return writeStream && [writeStream hasSpaceAvailable] && ([[NSDate date] timeIntervalSinceReferenceDate]>lastCommandOut+MIN_TIME_BETWEEN_CMDS);
}


- (BOOL)waitAndSendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	while (![self isReady]) {
  	[NSThread sleepForTimeInterval:0.005];
  }
  return [self sendDaliBridgeCommand:aCmd dali1:aDali1 dali2:aDali2];
}


- (BOOL)sendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2
{
	if ([self isReady]) {
  	// mark point of sending this
    lastCommandOut = [[NSDate date] timeIntervalSinceReferenceDate];
	  NSLog(@"sendDaliBridgeCommand:%d dali1:%d dali2:%d",aCmd,aDali1,aDali2);
  	// put bytes to stream
    uint8_t bridgeCmd[3];
    bridgeCmd[0] = aCmd;
    bridgeCmd[1] = aDali1;
    bridgeCmd[2] = aDali2;
    return [writeStream write:bridgeCmd maxLength:3]==3; // ok if we could send 3 bytes
  }
  else {
  	// not ready
	  NSLog(@"sendDaliBridgeCommand:not ready now");
    return NO;
  }
}



@end

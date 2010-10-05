//
//  DALIcomm.h
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 luz code&coins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>


@interface DALIcomm : NSObject <NSStreamDelegate>
{
	// host and port
  NSString *host;
  NSInteger port;
	// the streams
  NSInputStream *readStream;
  NSOutputStream *writeStream;
  // send pacing
  NSTimeInterval lastCommandOut;
}
- (void)setConnectionHost:(NSString *)aHost port:(NSInteger)aPort;
- (void)openConnection;
- (void)closeConnection;
- (BOOL)isReady;
- (BOOL)waitAndSendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2;
- (BOOL)sendDaliBridgeCommand:(uint8_t)aCmd dali1:(uint8_t)aDali1 dali2:(uint8_t)aDali2;

@end

//
//  MixLightsAppDelegate.m
//  MixLights
//
//  Created by Lukas Zeller on 2010/10/05.
//  Copyright 2010 Lukas Zeller/mixwerk.ch. All rights reserved.
//

#import "MixLightsAppDelegate.h"
#import "TechnoViewController.h"

@implementation MixLightsAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize daliComm;
@synthesize useTunnel;


+ (MixLightsAppDelegate *)sharedAppDelegate
{
	return (MixLightsAppDelegate *)([UIApplication sharedApplication].delegate);
}


- (NSString *)defaultBridgeAddress
{
  return @"192.168.59.200";
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// App properties
  application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	// init the defaults
  [[NSUserDefaults standardUserDefaults] registerDefaults:
  	[NSDictionary dictionaryWithObjectsAndKeys:
    	self.defaultBridgeAddress, @"DaliBridgeIP", // Digi Connect ME in MixWerk LAN (new VLAN: 59)
    	nil
    ]
  ];
	// create DALI communication handler    
  daliComm = [[DALIcomm alloc] init];
  useTunnel = NO;
  // Add the main view controller's view to the window and display.
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];

  return YES;
}


- (void)setUseTunnel:(BOOL)aUseTunnel
{
  if (aUseTunnel!=useTunnel) {
    useTunnel = aUseTunnel;
    [self initDaliComm];
  }
}


- (void)initDaliComm
{  
  [daliComm
    setConnectionHost:self.useTunnel ? @"127.0.0.1" : [[NSUserDefaults standardUserDefaults] stringForKey:@"DaliBridgeIP"]
    port:2101
  ]; // port = TCP raw access
}


- (void)prepareForPossibleTermination
{
  // save prefs
  [NSUserDefaults resetStandardUserDefaults];
  // close connection
  [daliComm closeConnection];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
  [daliComm closeConnection];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
   */
	// save such that we could terminate
	[self prepareForPossibleTermination];	
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
   */
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   See also applicationDidEnterBackground:.
   */
	// save such that we could terminate
	[self prepareForPossibleTermination];	
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}


- (void)dealloc
{
	// comm
  [daliComm release];
	// UI
  [window release];
  [super dealloc];
}

@end

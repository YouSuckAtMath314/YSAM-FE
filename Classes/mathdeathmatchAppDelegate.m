//
//  mathdeathmatchAppDelegate.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "mathdeathmatchAppDelegate.h"

#import "CEPubnub.h"

@implementation mathdeathmatchAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    viewController = [[StartScreenViewController alloc] init];

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

	pn = [[CEPubnub alloc] initWithPublishKey: @"demo" subscribeKey: @"demo" secretKey: nil sslOn: NO origin: @"pubsub.pubnub.com"];

	[pn subscribe: @"dbm_test" delegate: self];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
	NSLog(@"sub on channel (dict) : %@ - received: %@", channel, response);
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveArray:(NSArray *)response onChannel:(NSString *)channel
{
	NSLog(@"sub on channel (arr) : %@ - received: %@ - pubnub %@", channel, response, pubnub);
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveString:(NSString *)response onChannel:(NSString *)channel
{
	NSLog(@"sub on channel (str) : %@ - received: %@", channel, response);
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel
{
	NSLog(@"FAILURE sub on channel: %@ - received: %@", channel, response);
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveHistoryArray:(NSArray *)response onChannel:(NSString *)channel
{
	NSLog(@"HISTORY on channel (arr) : %@ - received: %@ - pubnub %@", channel, response, pubnub);
}

- (void)pubnub:(CEPubnub *)pubnub publishDidSucceedWithResponse:(NSString *)response onChannel:(NSString *)channel
{
	NSLog(@"publish on channel: %@ - received: %@", channel, response);
}

- (void)pubnub:(CEPubnub *)pubnub publishDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel
{
	NSLog(@"FAILURE publish on channel: %@ - received: %@", channel, response);
}

- (void)pubnub:(CEPubnub *)pubnub didReceiveTime:(NSString *)timestamp
{
	NSLog(@"Timestamp is %@ - pubnub %@", timestamp, pubnub);
}

@end

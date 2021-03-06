//
//  AppDelegate.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initPreferences];
    
    [self setRKLogging];
    
    return YES;
}
- (void)setRKLogging
{
    // shut up
    RKLogConfigureByName("RestKit", RKLogLevelOff);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
}
- (void)initPreferences
{
    NSArray *defaultObjects = [NSArray arrayWithObjects:LOCAL_SERVER_ADDRESS, [NSNumber numberWithInt:LOCAL_SERVER_PORT], nil];
    NSArray *defaultKeys = [NSArray arrayWithObjects:@"server_url", @"server_port", nil];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:defaultObjects
                                                            forKeys:defaultKeys];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // update server url, may have changed in preferences
    if ( ![[APIConnector instance].hostUrl isEqualToString:PREF_SERVER] ) {
        [APIConnector instance].hostUrl = PREF_SERVER;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

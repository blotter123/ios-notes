//
//  BTLAppDelegate.m
//  Notes
//
//  Created by Benedikt Lotter on 3/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "BTLNoteViewController.h"

@implementation BTLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BTLLocationManager *sharedLocationManager = [BTLLocationManager sharedLocationManager];
    [sharedLocationManager.locationManager startMonitoringSignificantLocationChanges];
    //[sharedLocationManager.locationManager startUpdatingLocation];
    // Override point for customization after application launch.
    
    if ((sharedLocationManager.locationManager.locationServicesEnabled)== NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you want to proceed, please enable lcoation services in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        //[servicesDisabledAlert];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    [[BTLLocationManager sharedLocationManager].locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    NSLog(@"applicationDidEnterBackground");
    
    [[BTLLocationManager sharedLocationManager].locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
    [[BTLLocationManager sharedLocationManager].locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    NSLog(@"applicationDidBecomeActive");
    
    BTLLocationManager *sharedLocationManager = [BTLLocationManager sharedLocationManager];
    
    //check through the locationManager whether the lcoation servcies are enabled
    if ((sharedLocationManager.locationManager.locationServicesEnabled)== NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you want to proceed, please enable lcoation services in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    //start monitoring location updates
    [sharedLocationManager.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    
   [[BTLLocationManager sharedLocationManager].locationManager stopMonitoringSignificantLocationChanges];
}

@end

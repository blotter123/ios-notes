//
//  BTLAppDelegate.h
//  Notes
//
//  Created by Benedikt Lotter on 3/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLLocationManager.h"

@interface BTLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//instance of singelton class to be shared between all classes
@property (strong, nonatomic) BTLLocationManager *sharedLocationManager;

@end

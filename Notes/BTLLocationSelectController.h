//
//  BTLLocationSelectController.h
//  Notes
//
//  Created by Benedikt Lotter on 3/11/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLNoteViewController.h"
#import "BTLTableViewController.h"
#import <CoreLocation/CoreLocation.h>


@protocol LocationSelectorDelegate <NSObject>

@optional

- (void)setLocation:(CLLocation*)location;

@end



@interface BTLLocationSelectController : UITableViewController <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <LocationSelectorDelegate> delegate;

@end

//
//  BTLTableViewController.h
//  Notes
//
//  Created by Benedikt Lotter on 3/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLLocationManager.h"

@interface BTLTableViewController : UITableViewController




@property (strong,nonatomic) NSMutableArray *notes; //elements in array are of type BTLNoteDetail
 

@end

//
//  Note.h
//  Notes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteDescription;
@property (nonatomic, retain) NSString * noteLocation;
@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) Location *hasLocation;

@end

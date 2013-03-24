//
//  Location.h
//  Notes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSSet *belongsToNotes;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addBelongsToNotesObject:(NSManagedObject *)value;
- (void)removeBelongsToNotesObject:(NSManagedObject *)value;
- (void)addBelongsToNotes:(NSSet *)values;
- (void)removeBelongsToNotes:(NSSet *)values;

@end

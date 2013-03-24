//
//  BTLDataManagers.h
//  Notes
//
//  Created by Benedikt Lotter on 3/23/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Note;
@interface BTLDataManagers : NSObject

- (BOOL)addNote:(double)lat longitude:(double)lon;
- (NSArray *)getAllNotes;
- (BOOL)updateNote:(Note *)note withTitle:(NSString *)text description:(NSString *)description latitude:(double)lat longitude:(double)lon;

- (NSManagedObjectContext *)managedObjectContext

@end

//
//  BTLDataManagers.m
//  Notes
//
//  Created by Benedikt Lotter on 3/23/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLDataManagers.h"
#import "Note.h"
#import "Location.h"

#import <CoreData/CoreData.h>

#define kBTLEntityName @"Note"
#define kBTLSaveError @"Whoops, couldn't save: %@"

@interface BTLDataManagers () 

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BTLDataManagers

- (BOOL)addNote:(double)lat longitude:(double)lon {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:kBTLEntityName inManagedObjectContext:context];
    note.noteTitle = @"New Title here";
    note.noteDescription = @"New Description here";
    note.hasLocation.latitude = [NSNumber numberWithDouble:lat];
    note.hasLocation.longitude = [NSNumber numberWithDouble:lon];
    NSError *error;
    if (![context save:&error]) {
        NSLog(kBTLSaveError, [error localizedDescription]);
        return NO;
    }
    return YES;
    
}


- (NSArray *)getAllNotes{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kBTLEntityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (BOOL)updateNote:(Note *)note withTitle:(NSString *)title description:(NSString *)description latitude:(double)lat longitude:(double)lon {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    note.noteTitle = title;
    note.noteDescription = description;
    note.hasLocation.longitude = [NSNumber numberWithDouble:lon];
    note.hasLocation.latitude = [NSNumber numberWithDouble:lat];
    NSError *error;
    if (![context save:&error]) {
        NSLog(kBTLSaveError, [error localizedDescription]);
        return NO;
    }
    return YES;
    
}




#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    /*
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Note" withExtension:@"momd"];
    NSLog(@"%@", modelURL);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    */
    NSManagedObjectModel *managedObjectContent= [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectContent;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Notes.sqlite"];
    
    NSLog(@"storeURL is %@", storeURL.absoluteString);
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSLog(@"%@", [self managedObjectModel]);
    NSLog(@"test");
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end

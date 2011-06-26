//
//  ManagedObjectContextContainer.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/4/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "Container.h"
#import "NSBundle+FileManagement.h"

/*!
 @category Container ()
 Extends the Container class by adding private methods.
 */
@interface Container ()

/*!
 @method copyBundledStoreFile:toURL:
 Copies the specified store file from the application bundle to the destination URL.
 @param name The name of the store file to copy.
 @param dstURL The destination URL where to copy the store file.
 */
- (void)copyBundledStoreFile:(NSString *)name toURL:(NSURL *)dstURL;

@end

@implementation Container

static Container *sharedInstance = nil;

+ (Container *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[Container alloc] init];
        }
        
        return sharedInstance;
    }
}

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}

- (NSManagedObjectContext *)managedObjectContext {    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QuoteBook" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString *storeFileName = @"QuoteBook.sqlite";
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFileName];
    
    [self copyBundledStoreFile:storeFileName toURL:storeURL];
    
    NSError *error = nil;
    persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                        configuration:nil
                                                                                  URL:storeURL
                                                                              options:nil
                                                                                error:&error];
    if (store == nil) {
        NSLog(@"Unresolved error %@, %@", error, error.description);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    }
    
    return persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)copyBundledStoreFile:(NSString *)name toURL:(NSURL *)dstURL {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[dstURL path]]) {
        return;
    }
    
    NSError *error = nil;
    BOOL isSuccessful = [[NSBundle mainBundle] copyResource:name toURL:dstURL error:&error];
    
    if (!isSuccessful) {
        NSLog(@"Failed to copy the database to the documents directory: %@ %@", error, error.description);
    }
}

@end
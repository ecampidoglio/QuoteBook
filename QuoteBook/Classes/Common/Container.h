//
//  ManagedObjectContextContainer.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/4/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <CoreData/CoreData.h>

/*!
 @class Container
 Aggregates and exposes objects shared throughout the application.
 */
@interface Container : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

/*!
 @method sharedInstance
 Gets the singleton instance of this class.
 @result Returns the singleton instance of the Container class.
 */
+ (Container *)sharedInstance;

/*!
 @property managedObjectContext
 @abstract Returns the managed object context for the application.
 @discussion If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

/*!
 @property managedObjectModel
 @abstract Returns the managed object model for the application.
 @discussion If the model doesn't already exist, it is created from the application's model.
 */
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

/*!
 @property persistentStoreCoordinator
 @abstract Returns the persistent store coordinator for the application.
 @discussion If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 @method applicationDocumentsDirectory
 Gets the URL to the application's Documents directory.
 @result Returns the URL to the application's Documents directory. 
 */
- (NSURL *)applicationDocumentsDirectory;

@end
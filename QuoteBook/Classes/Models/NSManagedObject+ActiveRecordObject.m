//
//  NSManagedObject+ActiveRecordObject.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/10/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "NSManagedObject+ActiveRecordObject.h"
#import "Container.h"

@implementation NSManagedObject (ActiveRecordObject)

- (BOOL)isTransient {
    return self.objectID.isTemporaryID;
}

- (BOOL)save:(NSError **)error {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    BOOL isSuccessful = YES;
    
    if ([context hasChanges]) {
        isSuccessful = [context save:error];
        
        if (!isSuccessful) {
            NSLog(@"Error: failed to persist managed object for entity name '%@' and ID '%@'",
                  self.entity.name,
                  self.objectID);
        }
    }
    
    return isSuccessful;
}

- (BOOL)delete:(NSError **)error {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    [context deleteObject:self];
    BOOL isSuccessful = [context save:error];
    
    if (!isSuccessful) {
        NSLog(@"Error: failed to delete managed object for entity name '%@' and ID '%@'",
              self.entity.name,
              self.objectID);
    }
    
    return isSuccessful;
}

@end
//
//  NSManagedObject+ActiveRecordObject.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/10/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

/*!
 @category NSManagedObject (ActiveRecordObject)
 Extends the NSManagedObject class by adding the methods defined by the ActiveRecordObject protocol.
 */
@interface NSManagedObject (ActiveRecordObject)

/*!
 @property isTransient
 Determines whether the current object has been persisted in the database.
 */ 
@property (nonatomic, readonly) BOOL isTransient; 

/*!
 @method save
 Persists the changes in the current object to the database.
 @param error Contains information about any errors that may have occurred during the operation.
 @result Returns a boolean value indicating whether the operation completed successfully.
 */
- (BOOL)save:(NSError **)error;

/*!
 @method delete
 Deletes the row that maps to the current object from the database.
 @param error Contains information about any errors that may have occurred during the operation.
 @result Returns a boolean value indicating whether the operation completed successfully.
 */
- (BOOL)delete:(NSError **)error;

@end
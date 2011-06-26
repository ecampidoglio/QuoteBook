//
//  ActiveRecordObject.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

/*!
 @protocol ActiveRecordObject
 @abstract Defines the interface of an object that directly maps to a record in a database table.
 @discussion An active record both contains the data from a specific row in a database table
 and allows to manipulate that data though insert, update and delete operations.
 */
@protocol ActiveRecordObject

/*!
 @property isTransient
 Determines whether the current object has been persisted in the database.
*/ 
@property (nonatomic, readonly) BOOL isTransient; 

/*!
 @method save
 Persists the changes in the current object to the database.
 @param error Contains information about any errors that may have occurred during the operation.
 */
- (void)save:(NSError **)error;

/*!
 @method delete
 Deletes the row that maps to the current object from the database.
 @param error Contains information about any errors that may have occurred during the operation.
 */
- (void)delete:(NSError **)error;

@end
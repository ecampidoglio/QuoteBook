//
//  Author.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <CoreData/CoreData.h>

/*!
 @class Quote
 Represents an author in the domain model of the application.
 */
@interface Author : NSManagedObject

/*!
 @method authorForInsert
 Creates and returns a transient Author object added to the managed object context.
 @result Returns a transient Author object.
 */
+ (Author *)authorForInsert;

/*!
 @method authorWithFullName
 Fetches the author that matches the specified name.
 @param fullName The full name of the author to fetch.
 @result A matching Author object or nil when none was found.
 */
+ (Author *)authorWithFullName:(NSString *)fullName;

/*!
 @property fullName
 Returns the first and last name of the author separated by a blank space.
 */
@property (nonatomic, retain) NSString *fullName;

/*!
 @property fullName
 Returns the initial letter of the author's first name
 */
@property (nonatomic, retain) NSString *fullNameInitial;

/*!
 @property fullName
 Returns the set of quotes associated to the author.
 */
@property (nonatomic, retain) NSSet *quotes;

@end
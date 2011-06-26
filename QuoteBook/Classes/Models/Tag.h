//
//  Tag.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Quote;

/*!
 @class Tag
 Represents a tag in the domain model of the application.
 */
@interface Tag : NSManagedObject

/*!
 @method tagForInsert
 Creates and returns a transient Tag object added to the managed object context.
 @result Returns a transient Tag object.
 */
+ (Tag *)tagForInsert;

/*!
 @method fetchRequestForAllTags
 Creates a NSFetchRequest that includes all tags in the results.
 @result Returns a properly configured NSFetchRequest object.
 */
+ (NSFetchRequest *)fetchRequestForAllTags;

/*!
 @property name
 Returns the name of the tag.
 */
@property (nonatomic, retain) NSString *name;

/*!
 @property quotes
 Returns the sequence of quotes that are associated with the tag.
 */
@property (nonatomic, retain) NSSet *quotes;

@end
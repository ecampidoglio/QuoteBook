//
//  Quote.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Author;
@class Tag;

/*!
 @class Quote
 Represents a quote in the domain model of the application.
 */
@interface Quote : NSManagedObject

/*!
 @method quoteForInsert
 Creates and returns a transient Quote object added to the managed object context.
 @result Returns a transient Quote object.
 */
+ (Quote *)quoteForInsert;

/*!
 @method fetchRequestForAllQuotes
 Creates a NSFetchRequest that includes all quotes in the results.
 @result Returns a properly configured NSFetchRequest object.
 */
+ (NSFetchRequest *)fetchRequestForAllQuotes;

/*!
 @method fetchRequestForItemsWithText:
 Creates a NSFetchRequest that includes quotes containing the specified text in the results.
 @result Returns a properly configured NSFetchRequest object.
 */
+ (NSFetchRequest *)fetchRequestForQuotesWithText:(NSString *)text;

/*!
 @method fetchRequestForQuotesWithAuthorName:
 Creates a NSFetchRequest that includes quotes whose author matches the specified name.
 @result Returns a properly configured NSFetchRequest object.
 */
+ (NSFetchRequest *)fetchRequestForQuotesWithAuthorName:(NSString *)authorName;

/*!
 @method fetchRequestForQuotesWithTagName:
 Creates a NSFetchRequest that includes quotes tagged with the specified name.
 @result Returns a properly configured NSFetchRequest object.
 */
+ (NSFetchRequest *)fetchRequestForQuotesWithTagName:(NSString *)tagName;

/*!
 @property isPreferred
 Returns a boolean value indicating whether the quote is marked as preferred by the user.
 */
@property (nonatomic, retain) NSNumber *isPreferred;

/*!
 @property text
 Returns the text of the quote.
 */
@property (nonatomic, retain) NSString *text;

/*!
 @property author
 Returns the author of the quote.
 */
@property (nonatomic, retain) Author *author;

/*!
 @property tags
 Returns the list of tags associated to the quote.
 */
@property (nonatomic, retain) NSSet *tags;

@end
//
//  QuoteTest.m
//  QuoteBook
//
//  Created by Enrico Campidoglio.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import "QuoteTest.h"
#import "Quote.h"

@implementation QuoteTest

- (void)testQuoteForInsert_ReturnsNotNull {
    Quote *result = [Quote quoteForInsert];
    
    STAssertNotNil(result, @"The method returned nil");
}

- (void)testQuoteForInsert_ReturnsPersistedQuote {
    Quote *result = [Quote quoteForInsert];
    
    STAssertTrue(result.objectID.isTemporaryID, @"The method returned a transient object");
}

@end
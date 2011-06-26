//
//  QuoteTest.m
//  QuoteBook
//
//  Created by Enrico Campidoglio.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuoteTest.h"
#import "Quote.h"

@implementation QuoteTest

- (void)testQuoteForInsert_ReturnsNotNull {
    Quote *result = [Quote quoteForInsert];
    
    STAssertNotNil(result, @"The method returned nil");
}

@end
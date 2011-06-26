//
//  QuoteTest.h
//  QuoteBook
//
//  Created by Enrico Campidoglio.
//  Copyright 2011 Thoughtology. All rights reserved.
//

@interface QuoteTest : SenTestCase {    
}

- (void)testQuoteForInsert_ReturnsNotNull;
- (void)testQuoteForInsert_ReturnsPersistedQuote;

@end
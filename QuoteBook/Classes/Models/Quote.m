// 
//  Quote.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "Quote.h"
#import "Container.h"

@implementation Quote 

+ (Quote *)quoteForInsert {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Quote"
                                                   inManagedObjectContext:context]; 
    Quote *quote = [[Quote alloc] initWithEntity:entityModel
                  insertIntoManagedObjectContext:context];
    
    return [quote autorelease];
}

+ (NSFetchRequest *)fetchRequestForAllQuotes {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Quote"
                                 inManagedObjectContext:context];
    NSSortDescriptor *authorLastNameInitialSort = [NSSortDescriptor sortDescriptorWithKey:@"author.fullName"
                                                                                ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:authorLastNameInitialSort, nil];
    request.fetchBatchSize = FETCH_REQUEST_BATCH_SIZE;
    
    return [request autorelease];
}

+ (NSFetchRequest *)fetchRequestForQuotesWithText:(NSString *)text {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Quote"
                                 inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"text like[cd] %@",
                         [NSString stringWithFormat:@"*%@*", text]];
    NSSortDescriptor *authorFullNameInitialSort = [NSSortDescriptor sortDescriptorWithKey:@"author.fullName"
                                                                                ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:authorFullNameInitialSort, nil];
    request.fetchBatchSize = FETCH_REQUEST_BATCH_SIZE;
    
    return [request autorelease];
}

+ (NSFetchRequest *)fetchRequestForQuotesWithAuthorName:(NSString *)authorName {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Quote"
                                 inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"author.fullName like[cd] %@",
                         [NSString stringWithFormat:@"*%@*", authorName]];
    NSSortDescriptor *authorFullNameInitialSort = [NSSortDescriptor sortDescriptorWithKey:@"author.fullName"
                                                                                ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:authorFullNameInitialSort, nil];
    request.fetchBatchSize = FETCH_REQUEST_BATCH_SIZE;
    
    return [request autorelease];
}

+ (NSFetchRequest *)fetchRequestForQuotesWithTagName:(NSString *)tagName {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Quote"
                                 inManagedObjectContext:context];
    // TODO: request.predicate = [NSPredicate predicateWithFormat:@" like[cd] %@",
    //                    [NSString stringWithFormat:@"*%@*", text]];
    NSSortDescriptor *authorFullNameInitialSort = [NSSortDescriptor sortDescriptorWithKey:@"author.fullName"
                                                                                ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:authorFullNameInitialSort, nil];
    
    return [request autorelease];
}

@dynamic text;
@dynamic isPreferred;
@dynamic author;
@dynamic tags;

@end
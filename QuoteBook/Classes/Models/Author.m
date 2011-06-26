// 
//  Author.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "Author.h"
#import "Container.h"

@implementation Author 

+ (Author *)authorForInsert {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Author"
                                                   inManagedObjectContext:context]; 
    Author *author = [[Author alloc] initWithEntity:entityModel
                     insertIntoManagedObjectContext:context];
    
    return [author autorelease];
}

+ (Author *)authorWithFullName:(NSString *)fullName {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Author"
                                 inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"fullName = %@", fullName];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    [request release];
    
    return [results lastObject];
}

@dynamic fullName;
@dynamic fullNameInitial;
@dynamic quotes;

- (NSString *)fullNameInitial {
    [self willAccessValueForKey:@"fullNameInitial"];
    NSString *value = @"...";
    
    if (self.fullName.length > 0) {
        value = [self.fullName substringToIndex:1];
    }
    
    [self didAccessValueForKey:@"fullNameInitial"];
    
    return value;
}

@end
// 
//  Tag.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/2/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "Tag.h"
#import "Container.h"

@implementation Tag 

+ (Tag *)tagForInsert {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Tag"
                                                   inManagedObjectContext:context]; 
    Tag *tag = [[Tag alloc] initWithEntity:entityModel
            insertIntoManagedObjectContext:context];
    
    return [tag autorelease];
}

+ (NSFetchRequest *)fetchRequestForAllTags {
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Tag"
                                 inManagedObjectContext:context];
    NSSortDescriptor *tagNameSort = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:tagNameSort, nil];
    
    return [request autorelease];
}

@dynamic name;
@dynamic quotes;

@end
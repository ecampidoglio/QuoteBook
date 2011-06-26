//
//  NSBundle+FileManagement.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/24/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "NSBundle+FileManagement.h"

@implementation NSBundle (FileManagement)

- (BOOL)copyResource:(NSString *)name toURL:(NSURL *)dstURL error:(NSError **)error {
    NSURL *resourceURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isSuccessful = [fileManager copyItemAtURL:resourceURL toURL:dstURL error:error];
    [fileManager release];
    
    return isSuccessful;
}

@end
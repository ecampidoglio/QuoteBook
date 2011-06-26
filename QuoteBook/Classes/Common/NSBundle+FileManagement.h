//
//  NSBundle+FileManagement.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/24/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

/*!
 @category NSBundle (FileManagement)
 Extends the NSBundle class by adding convenience file management operations.
 */
@interface NSBundle (FileManagement)

/*!
 @method copyResource:toURL:error
 Copies the resource file with the specified name from the application bundle to the specified file URL.
 @param name The name of the resource file to copy.
 @param dstURL The destination URL where to copy the resource file.
 @param error Contains information about any errors that may have occurred during the operation.
 @result Returns a Boolean value indicating whether the operation succeeded. 
 */
- (BOOL)copyResource:(NSString *)name toURL:(NSURL *)dstURL error:(NSError **)error;

@end
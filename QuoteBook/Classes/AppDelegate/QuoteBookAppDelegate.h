//
//  QuoteBookAppDelegate.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/1/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteBookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *controller;

@end
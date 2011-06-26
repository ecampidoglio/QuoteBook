//
//  QuotesViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/28/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuoteBookViewController.h"
#import "QuotesTableViewController.h"

/*!
 @category QuoteBookViewController()
 Extends the QuoteBookViewController class by adding private methods.
 */
@interface QuoteBookViewController ()

/*!
 @method displayQuotesButtonPressed:
 Responds to the event when the display quotes button did become pressed.
 @param button The button that was pressed.
 */
- (void)displayQuotesButtonPressed:(UIBarButtonItem *)button;

/*!
 @method addNavigationBarButtons
 Adds buttons to the navigation bar allowing to perform various operations on the quotes.
 */
- (void)addNavigationBarButtons;

/*!
 @method addToolbarButtons
 Adds buttons to the toolbar that allow to perform various operations on the quote.
 */
- (void)addToolbarButtons;

@end

@implementation QuoteBookViewController

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
    UIImage *backgroundImage = [UIImage imageNamed:@"OldPaper.jpg"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.view = backgroundImageView;
    [backgroundImageView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Quote Book";
    
    [self addNavigationBarButtons];
    [self addToolbarButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Actions

- (void)displayQuotesButtonPressed:(UIBarButtonItem *)button {
    QuotesTableViewController *quotesController =
    [[QuotesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:quotesController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:navController animated:YES];
    
    [quotesController release];
    [navController release];
}

#pragma mark -
#pragma mark Utility methods

- (void)addNavigationBarButtons {
    UIBarButtonItem *displayQuotesButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Quotes"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(displayQuotesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = displayQuotesButton;
    [displayQuotesButton release];
}

- (void)addToolbarButtons {
    UIBarButtonItem *shuffleQuotesButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Shuffle.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(shuffleQuotesButtonPressed:)];
    
    UIBarButtonItem *previousQuoteButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowLeft.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(previousQuotesButtonPressed:)];
    
    UIBarButtonItem *nextQuoteButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowRight.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(nextQuotesButtonPressed:)];
    
    UIBarButtonItem *shareQuoteButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(nextQuotesButtonPressed:)];
    
    UIBarButtonItem *separatorButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         shuffleQuotesButton,
                         separatorButton,
                         previousQuoteButton,
                         separatorButton,
                         nextQuoteButton,
                         separatorButton,
                         shareQuoteButton,
                         nil];
    
    [shuffleQuotesButton release];
    [previousQuoteButton release];
    [nextQuoteButton release];
    [shareQuoteButton release];
    [separatorButton release];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end
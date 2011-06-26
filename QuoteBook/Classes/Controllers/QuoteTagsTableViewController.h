//
//  QuoteTagsTableViewController.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/17/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

@class Quote;

/*!
 @class QuoteTagsTableViewController
 The controller for the view containing a TableView listing the available tags that are associated to a quote.
 */
@interface QuoteTagsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    Quote *quote;
    NSMutableSet *selectedTags;
    NSFetchedResultsController *contentsController;
}

/*!
 @property quote
 Returns the quote currently being displayed by the controller.
 */
@property (nonatomic, retain) Quote *quote;

@end
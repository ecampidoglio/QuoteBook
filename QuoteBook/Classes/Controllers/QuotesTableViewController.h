//
//  QuoteTableViewController.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/10/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

/*!
 @class QuotesTableViewController
 The controller for the view containing a table view listing the available quotes.
 */
@interface QuotesTableViewController : UITableViewController <UISearchBarDelegate,
NSFetchedResultsControllerDelegate> {
    UISearchBar *searchBar;
    UISearchDisplayController *searchController;
    NSFetchedResultsController *contentsController;
    NSDictionary *searchResults;
    BOOL isSearching;
}

@end
//
//  QuoteTableViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/10/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuotesTableViewController.h"
#import "QuoteDetailsViewController.h"
#import "QuoteModalViewController.h"
#import "Container.h"
#import "Quote.h"
#import "Author.h"
#import "Tag.h"
#import "NSManagedObject+ActiveRecordObject.h"

/*!
 @category QuotesTableViewController()
 Extends the QuotesTableViewController class by adding private methods.
 */
@interface QuotesTableViewController ()

/*!
 @property searchBar
 Returns the search bar used to filter the list of quotes.
 */
@property (nonatomic, retain) UISearchBar *searchBar;

/*!
 @property searchController
 Returns the search display controller used to managed the results of a search.
 */
@property (nonatomic, retain) UISearchDisplayController *searchController;

/*!
 @property contentsController
 Returns the fetched results controller used to manage the list of quotes.
 */
@property (nonatomic, retain) NSFetchedResultsController *contentsController;

/*!
 @method displayQuoteBookButtonPressed:
 Notifies when the display quote book button was pressed.
 @param button The button that was pressed.
 */
- (void)displayQuoteBookButtonPressed:(UIBarButtonItem *)button;

/*!
 @method addQuoteButtonPressed:
 Notifies when the add quote button was pressed.
 @param button The button that was pressed.
 */
- (void)addQuoteButtonPressed:(UIBarButtonItem *)button;

/*!
 @method configureCell:atIndexPath:
 Configures the table view cell at the specified index path.
 @param cell The table view cell to configure.
 @param indexPath The index path of the cell to configure.
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/*!
 @method predicateForSearchString:withScopeIndex:
 Returns a search predicate with the specified string within the specified scope.
 @param searchString The text of the search string.
 @param scopeIndex The index of the search scope.
 @result A properly configured NSPredicate object.
 */
- (NSPredicate *)predicateForSearchString:(NSString *)searchString withScopeIndex:(NSInteger)scopeIndex;

/*!
 @method performSearch:
 @param error Contains information about any errors that may have occurred during the operation.
 @result A boolean value indicating whether the operation completed successfully.
 */
- (BOOL)performSearch:(NSError **)error;

/*!
 @method pushDetailsViewControllerWithQuote:
 Pushes the QuoteDetailsViewController in the navigation controller.
 @param quote The Quote object to be displayed in the view.
 */
- (void)pushDetailsViewControllerWithQuote:(Quote *)quote;

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

/*!
 @typedef QuoteSearchScopeIndex
 The indexes of the scopes used to search quotes. 
 */
typedef enum {
    QuoteSearchScopeIndexAuthor = 0,
    QuoteSearchScopeIndexText = 1,
    QuoteSearchScopeIndexTag = 2
} QuoteSearchScopeIndex;

/*!
 @const MinSearchStringLength
 The least number of characters required for a search string in order to trigger a search.
 */
static NSInteger const MinSearchStringLength = 3;

/*!
 @const ContentsCacheName
 The cache identifier for the contents controller.
 */
static NSString *const ContentsCacheName = @"Quotes";

@implementation QuotesTableViewController

@synthesize searchBar, searchController, contentsController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Author", @"Quote", @"Tag", nil];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                              contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    self.contentsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:[Quote fetchRequestForAllQuotes]
                                        managedObjectContext:context
                                          sectionNameKeyPath:@"author.fullName"
                                                   cacheName:ContentsCacheName];
    self.contentsController.delegate = self;
    
    self.title = @"Quotes";
    self.tableView.tableHeaderView = self.searchBar;
    
    [self addNavigationBarButtons];
    [self addToolbarButtons];
    [self.contentsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleDefault;
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.toolbarHidden = NO;
    self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.contentsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // We remove the item in the model since the table view
    // will be updated by the fetched results controller
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Quote *selectedQuote = [self.contentsController objectAtIndexPath:indexPath];
        [selectedQuote delete:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.contentsController.sections objectAtIndex:section];
    return sectionInfo.name;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSSet *sectionIndexTitles = [NSSet setWithArray:[self.contentsController sectionIndexTitles]];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]];
    
    NSMutableArray *results = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    [results addObjectsFromArray:[[sectionIndexTitles allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
    
    return results;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    // TODO: broken
    return [self.contentsController sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Quote *selectedQuote = [self.contentsController objectAtIndexPath:indexPath];
    [self pushDetailsViewControllerWithQuote:selectedQuote];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Quote *selectedQuote = [self.contentsController objectAtIndexPath:indexPath];
    [self pushDetailsViewControllerWithQuote:selectedQuote];
}

#pragma mark -
#pragma mark Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self performSearch:nil];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self performSearch:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [NSFetchedResultsController deleteCacheWithName:ContentsCacheName];
    self.contentsController.fetchRequest.predicate = [Quote fetchRequestForAllQuotes].predicate;
    [self.contentsController performFetch:nil];
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationLeft];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
    }
}

#pragma mark -
#pragma mark Actions

- (void)displayQuoteBookButtonPressed:(UIBarButtonItem *)button {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addQuoteButtonPressed:(UIBarButtonItem *)button {
    QuoteModalViewController *quoteController =
    [[QuoteModalViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:quoteController];
    [self presentModalViewController:navController animated:YES];
    
    [quoteController release];
    [navController release];
}

- (void)loadQuotesButtonPressed:(UIBarButtonItem *)button {
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"Quotes" withExtension:@"plist"];
    NSArray *quotes = [NSArray arrayWithContentsOfURL:plistURL];
    
    for (NSDictionary *quote in quotes) {
        NSString *authorName = [[quote allKeys] lastObject];
        NSString *quoteText = [[quote allValues] lastObject];
        Quote *quoteObject = [Quote quoteForInsert];
        Author *authorObject = [Author authorWithFullName:authorName];
        
        if (authorObject == nil) {
            authorObject = [Author authorForInsert];
            authorObject.fullName = [authorName length] > 0 ? authorName : @"Anonymous";
        }        
        
        quoteObject.author = authorObject;
        quoteObject.text = quoteText;
        
        NSError *error;
        
        if (![quoteObject save:&error]) {
            NSLog(@"Error importing quotes: %@", error.description);
        }
    }
    
    NSLog(@"Successfully imported %i quotes", quotes.count);
}

#pragma mark -
#pragma mark Utility methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Quote *quote = [self.contentsController objectAtIndexPath:indexPath];
    cell.textLabel.text = quote.text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSPredicate *)predicateForSearchString:(NSString *)searchString withScopeIndex:(NSInteger)scopeIndex {
    NSFetchRequest *searchRequest = nil;
    
    switch (scopeIndex) {
        case QuoteSearchScopeIndexAuthor:
            searchRequest = [Quote fetchRequestForQuotesWithAuthorName:searchString];
            break;
        case QuoteSearchScopeIndexText:
            searchRequest = [Quote fetchRequestForQuotesWithText:searchString];
            break;
        case QuoteSearchScopeIndexTag:
            searchRequest = [Quote fetchRequestForQuotesWithTagName:searchString];
            break;
    }
    
    return searchRequest.predicate;
}

- (BOOL)performSearch:(NSError **)error {
    NSString *searchString = self.searchBar.text;
    NSInteger searchScopeIndex = self.searchBar.selectedScopeButtonIndex;
    
    if (searchString.length < MinSearchStringLength) {
        return NO;
    }
    
    UIActivityIndicatorView *spinner =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:spinner];
    [spinner release];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSFetchedResultsController deleteCacheWithName:ContentsCacheName];
        self.contentsController.fetchRequest.predicate = [self predicateForSearchString:searchString
                                                                         withScopeIndex:searchScopeIndex];
        [self.contentsController performFetch:error];
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
    
    return error == nil;
}

- (void)pushDetailsViewControllerWithQuote:(Quote *)quote {
    QuoteDetailsViewController *detailsViewController =
    [[QuoteDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailsViewController.quote = quote;
    [self.navigationController pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}

- (void)addNavigationBarButtons {
    UIBarButtonItem *displayQuoteBookButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Book"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(displayQuoteBookButtonPressed:)];
    
    UIBarButtonItem *addQuoteButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addQuoteButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = displayQuoteBookButton;
    self.navigationItem.rightBarButtonItem = addQuoteButton;
    
    [displayQuoteBookButton release];
    [addQuoteButton release];
}

- (void)addToolbarButtons {
    UIBarButtonItem *loadQuotesButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(loadQuotesButtonPressed:)];
    self.toolbarItems = [NSArray arrayWithObject:loadQuotesButton];
    [loadQuotesButton release];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    self.searchBar = nil;
    self.searchController = nil;
    self.contentsController = nil;
}

- (void)dealloc {
    [searchBar release];
    [searchController release];
    [contentsController release];
    [super dealloc];
}

@end
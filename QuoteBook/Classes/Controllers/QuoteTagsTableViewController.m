//
//  QuoteTagsTableViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/17/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuoteTagsTableViewController.h"
#import "TagModalViewController.h"
#import "Container.h"
#import "Quote.h"
#import "Tag.h"
#import "NSManagedObject+ActiveRecordObject.h"

/*!
 @category QuoteTagsTableViewController()
 Extends the QuoteTagsTableViewController class by adding private methods.
 */
@interface QuoteTagsTableViewController ()

/*!
 @property selectedTags
 Returns the set of tags that have been selected through the table view. 
 */
@property (nonatomic, retain) NSMutableSet *selectedTags;

/*!
 @property contentsController
 Returns the fetched results controller used to manage the list of tags.
 */
@property (nonatomic, retain) NSFetchedResultsController *contentsController;

/*!
 @method addTagButtonPressed:
 Responds to the event when the add tag button did become pressed.
 @param button The button that was pressed.
 */
- (void)addTagButtonPressed:(UIBarButtonItem *)button;

/*!
 @method configureCell:atIndexPath:
 Configures the table view cell at the specified index path.
 @param cell The table view cell to configure.
 @param indexPath The index path of the cell to configure.
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/*!
 @method toggleCheckmarkStatusForCell:
 Sets or removes the checkmark accessory type for a cell based on
 whether the specified tag belongs to the quote currently displayed by the controller.
 @param cell The table view cell to modify the accessory type for.
 @param tag The tag used to determine whether the cell will have a checkmark accessory or not.
 */
- (void)setCheckmarkStatusForCell:(UITableViewCell *)cell basedOnTag:(Tag *)tag;

/*!
 @method toggleCheckmarkStatusForCell:
 Toggles the checkmark accessory type for the specified cell.
 @param cell The table view cell to modify the accessory type for.
 */
- (void)toggleCheckmarkStatusForCell:(UITableViewCell *)cell;

/*!
 @method addNavigationBarButtons
 Adds buttons to the navigation bar allowing to perform various operations on the tags.
 */
- (void)addNavigationBarButtons;

@end

@implementation QuoteTagsTableViewController

@synthesize quote;
@synthesize selectedTags, contentsController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTags = [NSMutableSet set];
    NSManagedObjectContext *context = [Container sharedInstance].managedObjectContext;
    self.contentsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Tag fetchRequestForAllTags]
                                                                  managedObjectContext:context
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:nil];
    self.contentsController.delegate = self;
    
    self.title = @"Quote Tags";
    
    [self addNavigationBarButtons];
    [self.contentsController performFetch:nil];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Tag *selectedTag = [self.contentsController objectAtIndexPath:indexPath];
        [selectedTag delete:nil];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self toggleCheckmarkStatusForCell:cell];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    }
}

#pragma mark -
#pragma mark Actions

- (void)addTagButtonPressed:(UIBarButtonItem *)button {
    TagModalViewController *tagController = [[TagModalViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:tagController];
    
    [self presentModalViewController:navController animated:YES];
    
    [tagController release];
    [navController release];
}

#pragma mark -
#pragma mark Utility methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tag *tag = [self.contentsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.imageView.image = [UIImage imageNamed:@"Tag.png"];
    
    [self setCheckmarkStatusForCell:cell basedOnTag:tag];
}

- (void)setCheckmarkStatusForCell:(UITableViewCell *)cell basedOnTag:(Tag *)tag {
    if ([self.quote.tags containsObject:tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedTags addObject:tag];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)toggleCheckmarkStatusForCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tag *tag = [self.contentsController objectAtIndexPath:indexPath];
    UITableViewCellAccessoryType newAccessoryType;
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        newAccessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedTags addObject:tag];
    } else {
        newAccessoryType = UITableViewCellAccessoryNone;
        [self.selectedTags removeObject:tag];
    }
    
    cell.accessoryType = newAccessoryType;
}

- (void)addNavigationBarButtons {
    UIBarButtonItem *addTagButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addTagButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addTagButton;
    [addTagButton release];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    self.selectedTags = nil;
    self.contentsController = nil;
}

- (void)dealloc {
    [selectedTags release];
    [contentsController release];
    [super dealloc];
}

@end
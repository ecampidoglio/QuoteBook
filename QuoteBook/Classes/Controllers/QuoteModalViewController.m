//
//  QuoteModalViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/13/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuoteModalViewController.h"
#import "QuoteTagsTableViewController.h"
#import "Quote.h"
#import "Author.h"
#import "NSManagedObject+ActiveRecordObject.h"

/*!
 @category QuoteModalViewController()
 Extends the QuoteModalViewController class by adding private methods.
 */
@interface QuoteModalViewController ()

/*!
 @property quote
 Returns the quote currently being edited by the controller.
 */
@property (nonatomic, retain) Quote *quote;

/*!
 @property quoteAuthorNameTextField
 Returns the text view used to display and edit the name of the quote's author.
 */
@property (nonatomic, retain) UITextField *quoteAuthorNameTextField;

/*!
 @property quoteTextView
 Returns the UITextView used to display and edit the text of the quote.
 */
@property (nonatomic, retain) UITextView *quoteTextView;

/*!
 @method saveQuoteButtonPressed:
 Responds to the event when the save quote button did become pressed.
 @param button The button that was pressed.
 */
- (void)saveQuoteButtonPressed:(UIBarButtonItem *)button;

/*!
 @method cancelButtonPressed:
 Responds to the event when the cancel button did become pressed.
 @param button The button that was pressed.
 */
- (void)cancelButtonPressed:(UIBarButtonItem *)button;

/*!
 @method doneButtonPressed:
 Responds to the event when the done button did become pressed.
 @param button The button that was pressed.
 */
- (void)doneButtonPressed:(UIBarButtonItem *)button;

/*!
 @method addNavigationBarButtons
 Adds buttons to the navigation bar allowing the user to perform various operations on the tags.
 */
- (void)addNavigationBarButtons;

/*!
 @method addDoneButton
 Adds a button to the navigation bar allowing the user to dismiss the keyboard.
 */
- (void)addDoneButton;

/*!
 @method pushQuoteTagsTableViewControllerWithQuote:
 Pushes the QuoteTagsTableViewController in the navigation controller.
 @param quote The Quote object to be displayed in the view.
 */
- (void)pushQuoteTagsTableViewControllerWithQuote:(Quote *)quote;

/*!
 @method scrollQuoteTextViewToTop
 Sets the position of the quote's text view to the top of the table view.
 */
- (void)scrollQuoteTextViewToTop;

/*!
 @method scrollQuoteTextViewContentToTop
 Sets the position of the quote's text view visible content to the top.
 */
- (void)scrollQuoteTextViewContentToTop;

@end

/*!
 @typedef QuoteDetailsTableViewSection
 The sections of the table view used to display detailed information about a quote.
 */
typedef enum {
    QuoteModalTableViewSectionAuthor = 0,
    QuoteModalTableViewSectionText = 1,
    QuoteModalTableViewSectionTags = 2
} QuoteModalTableViewSection;

@implementation QuoteModalViewController

@synthesize quote, quoteAuthorNameTextField, quoteTextView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quote = [Quote quoteForInsert];
    
    self.quoteAuthorNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 11, 260, 45)];
    self.quoteAuthorNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.quoteAuthorNameTextField.delegate = self;
    
    self.quoteTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, 5, 275, 135)];
    self.quoteTextView.font = [UIFont systemFontOfSize:17];
    self.quoteTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.quoteTextView.delegate = self;
    
    self.title = @"New Quote";
    self.tableView.scrollEnabled = NO;
    
    [self addNavigationBarButtons];
    [self.quoteAuthorNameTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.tableView.scrollEnabled = (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                                    toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (self.tableView.scrollEnabled) {
        [self.tableView flashScrollIndicators];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:nil] autorelease];
    
    switch (indexPath.section) {
        case QuoteModalTableViewSectionAuthor: {
            cell.imageView.image = [UIImage imageNamed:@"Author.png"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.quoteAuthorNameTextField];
            break;
        }
        case QuoteModalTableViewSectionText: {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Quote.png"]];
            iconView.frame = CGRectMake(10, 17, iconView.bounds.size.width, iconView.bounds.size.height);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:iconView];
            [cell.contentView addSubview:self.quoteTextView];
            [iconView release];
            break;
        }
        case QuoteModalTableViewSectionTags: {
            cell.imageView.image = [UIImage imageNamed:@"Tag.png"];
            cell.textLabel.text = @"Tags";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionHeaderTitle = nil;
    
    switch (section) {
        case QuoteModalTableViewSectionAuthor:
            sectionHeaderTitle = @"Author";
            break;
        case QuoteModalTableViewSectionText:
            sectionHeaderTitle = @"Quote";
            break;
    }
    
    return sectionHeaderTitle;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    
    if (indexPath.section == QuoteModalTableViewSectionText) {
        rowHeight = self.quoteTextView.frame.size.height + 20;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QuoteModalTableViewSectionTags) {
        [self pushQuoteTagsTableViewControllerWithQuote:self.quote];
    }
}

#pragma mark -
#pragma mark Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self addDoneButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self addNavigationBarButtons];
}

#pragma mark -
#pragma mark Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self addDoneButton];
    [self scrollQuoteTextViewToTop];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self addNavigationBarButtons];
    [self scrollQuoteTextViewContentToTop];
}

#pragma mark -
#pragma mark Actions

- (void)saveQuoteButtonPressed:(UIBarButtonItem *)button {
    NSString *authorFullName = self.quoteAuthorNameTextField.text;
    Author *author = [Author authorWithFullName:authorFullName];
    
    if (author == nil) {
        author = [Author authorForInsert];
        author.fullName = authorFullName;
    }
    
    self.quote.author = author;
    self.quote.text = self.quoteTextView.text;
    [self.quote save:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(UIBarButtonItem *)button {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Utility methods

- (void)addNavigationBarButtons {
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *saveTagButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveQuoteButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveTagButton;
    
    [cancelButton release];
    [saveTagButton release];
}

- (void)addDoneButton {
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)pushQuoteTagsTableViewControllerWithQuote:(Quote *)quote {
    QuoteTagsTableViewController *quoteTagsController =
    [[QuoteTagsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    quoteTagsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quoteTagsController animated:YES];
    [quoteTagsController release];
}

- (void)scrollQuoteTextViewToTop {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                              inSection:QuoteModalTableViewSectionText]
                          atScrollPosition:UITableViewScrollPositionTop 
                                  animated:YES];
}

- (void)scrollQuoteTextViewContentToTop {
    [self.quoteTextView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    self.quote = nil;
    self.quoteAuthorNameTextField = nil;
    self.quoteTextView = nil;
}

- (void)dealloc {
    [quote release];
    [quoteAuthorNameTextField release];
    [quoteTextView release];
    [super dealloc];
}

@end
//
//  QuoteDetailsViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/13/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "QuoteDetailsViewController.h"
#import "QuoteTagsTableViewController.h"
#import "Quote.h"
#import "Author.h"
#import "NSManagedObject+ActiveRecordObject.h"
#import <MessageUI/MFMailComposeViewController.h>

/*!
 @category QuoteDetailsViewController()
 Extends the QuoteDetailsViewController class by adding private methods.
 */
@interface QuoteDetailsViewController ()

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
 @method deleteQuoteButtonPressed:
 Responds to the event when the delete quote button did become pressed.
 @param button The button that was pressed.
 */
- (void)deleteQuoteButtonPressed:(UIBarButtonItem *)button;

/*!
 @method likeQuoteButtonPressed:
 Responds to the event when the like quote button did become pressed.
 @param button The button that was pressed.
 */
- (void)likeQuoteButtonPressed:(UIBarButtonItem *)button;

/*!
 @method shareQuoteButtonPressed:
 Responds to the event when the share quote button did become pressed.
 @param button The button that was pressed.
 */
- (void)shareQuoteButtonPressed:(UIBarButtonItem *)button;

/*!
 @method saveQuote
 Saves the modifications made to the Quote object through the view.
 */
- (void)saveQuote;

/*!
 @method shareQuoteByEmail
 Allows the user to compose an e-mail to share the quote.
 */
- (void)shareQuoteByEmail;

/*!
 @method pushQuoteTagsTableViewControllerWithQuote:
 Pushes the QuoteTagsTableViewController in the navigation controller.
 @param quote The Quote object to be displayed in the view.
 */
- (void)pushQuoteTagsTableViewControllerWithQuote:(Quote *)quote;

/*!
 @method addToolbarButtons
 Adds buttons to the toolbar that allow to perform various operations on the quote.
 */
- (void)addToolbarButtons;

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
    QuoteDetailsTableViewSectionAuthor = 0,
    QuoteDetailsTableViewSectionText = 1,
    QuoteDetailsTableViewSectionTags = 2
} QuoteDetailsTableViewSection;

@implementation QuoteDetailsViewController

@synthesize quote;
@synthesize quoteAuthorNameTextField, quoteTextView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    self.quoteAuthorNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 11, 260, 45)];
    self.quoteAuthorNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.quoteAuthorNameTextField.userInteractionEnabled = NO;
    self.quoteAuthorNameTextField.text = self.quote.author.fullName;
    
    self.quoteTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, 5, 275, 135)];
    self.quoteTextView.font = [UIFont systemFontOfSize:17];
    self.quoteTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.quoteTextView.userInteractionEnabled = NO;
    self.quoteTextView.text = self.quote.text;
    self.quoteTextView.delegate = self;
    
    self.title = @"Edit Quote";
    self.tableView.scrollEnabled = NO;
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    
    [self addToolbarButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.tableView.editing = NO;
    self.quoteAuthorNameTextField.userInteractionEnabled = editing;
    self.quoteTextView.userInteractionEnabled = editing;
    
    if (editing) {
        [self.quoteAuthorNameTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
        [self saveQuote];
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
        case QuoteDetailsTableViewSectionAuthor: {
            cell.imageView.image = [UIImage imageNamed:@"Author.png"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.quoteAuthorNameTextField];
            break;
        }
        case QuoteDetailsTableViewSectionText: {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Quote.png"]];
            iconView.frame = CGRectMake(10, 17, iconView.bounds.size.width, iconView.bounds.size.height);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:iconView];
            [cell.contentView addSubview:self.quoteTextView];
            [iconView release];
            break;
        }
        case QuoteDetailsTableViewSectionTags: {
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
        case QuoteDetailsTableViewSectionAuthor:
            sectionHeaderTitle = @"Author";
            break;
        case QuoteDetailsTableViewSectionText:
            sectionHeaderTitle = @"Quote";
            break;
    }
    
    return sectionHeaderTitle;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    
    if (indexPath.section == QuoteDetailsTableViewSectionText) {
        rowHeight = self.quoteTextView.frame.size.height + 20;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QuoteDetailsTableViewSectionTags) {
        [self pushQuoteTagsTableViewControllerWithQuote:self.quote];
    }
}

#pragma mark -
#pragma mark Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollQuoteTextViewToTop];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self scrollQuoteTextViewContentToTop];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.quote delete:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self shareQuoteByEmail];
    }
}

#pragma mark -
#pragma mark Mail compose view controller delete

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Actions

- (void)deleteQuoteButtonPressed:(UIBarButtonItem *)button {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete quote"
                                                    otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:button animated:YES];
    [actionSheet release];
}

- (void)likeQuoteButtonPressed:(UIBarButtonItem *)button {
    self.quote.isPreferred = [NSNumber numberWithBool:!self.quote.isPreferred.boolValue];
    [self saveQuote];
    button.image = self.quote.isPreferred.boolValue ?
    [UIImage imageNamed:@"RemovePreferredQuote.png"] : [UIImage imageNamed:@"AddPreferredQuote.png"];
}

- (void)shareQuoteButtonPressed:(UIBarButtonItem *)button {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Share via e-mail", nil];
    [actionSheet showFromBarButtonItem:button animated:YES];
    [actionSheet release];
}

#pragma mark -
#pragma mark Utility methods

- (void)saveQuote {
    NSString *authorName = self.quoteAuthorNameTextField.text;
    NSString *quoteText = self.quoteTextView.text; 
    
    if (![self.quote.author.fullName isEqualToString:authorName]) {
        self.quote.author.fullName = authorName;
    }
    
    if (![self.quote.text isEqualToString:quoteText]) {
        self.quote.text = quoteText;
    }
    
    [self.quote save:nil];
}

- (void)shareQuoteByEmail {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No e-mail account has been configured"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        [errorView show];
        [errorView release];
    }
    
    [mailViewController setSubject:[NSString stringWithFormat:@"Quote by %@", self.quote.author.fullName]];
    [mailViewController setMessageBody:[NSString stringWithFormat:@"""%@""", self.quote.text] isHTML:NO];
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
}

- (void)pushQuoteTagsTableViewControllerWithQuote:(Quote *)quote {
    QuoteTagsTableViewController *quoteTagsController =
    [[QuoteTagsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    quoteTagsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quoteTagsController animated:YES];
    [quoteTagsController release];
}

- (void)addToolbarButtons {
    UIBarButtonItem *deleteQuoteButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                  target:self
                                                  action:@selector(deleteQuoteButtonPressed:)];
    
    UIImage *likeQuoteButtonImage = self.quote.isPreferred.boolValue ?
    [UIImage imageNamed:@"RemovePreferredQuote.png"] : [UIImage imageNamed:@"AddPreferredQuote.png"];
    UIBarButtonItem *likeQuoteButton =
    [[UIBarButtonItem alloc] initWithImage:likeQuoteButtonImage
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(likeQuoteButtonPressed:)];
    
    UIBarButtonItem *shareQuoteButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(shareQuoteButtonPressed:)];
    UIBarButtonItem *separatorButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:deleteQuoteButton,
                         separatorButton,
                         likeQuoteButton,
                         separatorButton,
                         shareQuoteButton,
                         nil];
    [deleteQuoteButton release];
    [likeQuoteButton release];
    [shareQuoteButton release];
    [separatorButton release];
}

- (void)scrollQuoteTextViewToTop {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                              inSection:QuoteDetailsTableViewSectionText]
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
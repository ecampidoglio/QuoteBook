//
//  TagModalViewController.m
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/18/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import "TagModalViewController.h"
#import "Tag.h"
#import "NSManagedObject+ActiveRecordObject.h"

/*!
 @category TagModalViewController()
 Extends the TagModalViewController class by adding private methods.
 */
@interface TagModalViewController ()

/*!
 @property tagNameTextField
 Returns the text field containing the tag's descriptive name.
 */
@property (nonatomic, retain) UITextField *tagNameTextField;

/*!
 @method saveTagButtonPressed:
 Responds to the event when the save tag button did become pressed.
 @param button The button that was pressed.
 */
- (void)saveTagButtonPressed:(UIBarButtonItem *)button;

/*!
 @method cancelButtonPressed:
 Responds to the event when the cancel button did become pressed.
 @param button The button that was pressed.
 */
- (void)cancelButtonPressed:(UIBarButtonItem *)button;

/*!
 @method addNavigationBarButtons
 Adds buttons to the navigation bar allowing to perform various operations on the tags.
 */
- (void)addNavigationBarButtons;

@end

@implementation TagModalViewController

@synthesize tagNameTextField;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 11, 260, 45)];
    
    self.title = @"New Tag";
    self.tableView.scrollEnabled = NO;
    
    [self addNavigationBarButtons];
    [self.tagNameTextField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:nil] autorelease];
    cell.imageView.image = [UIImage imageNamed:@"Tag.png"];
    [cell.contentView addSubview:self.tagNameTextField];
    
    return cell;
}

#pragma mark -
#pragma mark Actions

- (void)saveTagButtonPressed:(UIBarButtonItem *)button {
    Tag *tag = [Tag tagForInsert];
    tag.name = self.tagNameTextField.text;
    [tag save:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button {
    [self dismissModalViewControllerAnimated:YES];
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
                                                  action:@selector(saveTagButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveTagButton;
    
    [cancelButton release];
    [saveTagButton release];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tagNameTextField = nil;
}

- (void)dealloc {
    [tagNameTextField release];
    [super dealloc];
}

@end
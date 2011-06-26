//
//  QuoteDetailsViewController.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/13/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>

@class Quote;

/*!
 @class QuoteDetailsViewController
 The controller for the view containing a TableView used to display and edit a quote.
 */
@interface QuoteDetailsViewController : UITableViewController <UITextViewDelegate,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate> {
    Quote *quote;
    UITextField *quoteAuthorNameTextField;
    UITextView *quoteTextView;
}

/*!
 @property quote
 Returns the quote currently being displayed by the controller.
 */
@property (nonatomic, retain) Quote *quote;

@end
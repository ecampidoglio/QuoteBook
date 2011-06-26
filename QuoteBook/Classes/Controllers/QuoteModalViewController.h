//
//  QuoteModalViewController.h
//  QuoteBook
//
//  Created by Enrico Campidoglio on 1/13/11.
//  Copyright 2011 Thoughtology. All rights reserved.
//

@class Quote;

/*!
 @class QuoteModalViewController
 The controller for the view containing a TableView used to create a new quote.
 */
@interface QuoteModalViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate> {
    Quote *quote;
    UITextField *quoteAuthorNameTextField;
    UITextView *quoteTextView;
}

@end
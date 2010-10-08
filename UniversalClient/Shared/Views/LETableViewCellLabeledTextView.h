//
//  LETableViewCellLabeledTextView.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLabeledTextView : UITableViewCell <UITextInputTraits>  {
	UILabel *label;
	UITextView *textView;
	id<UITextViewDelegate> delegate;
}


@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<UITextViewDelegate> delegate;
@property (nonatomic, assign) BOOL enabled;


- (NSString *)value;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (void)dismissKeyboard;
- (void)clearText;


+ (LETableViewCellLabeledTextView *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

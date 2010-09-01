//
//  LETableViewCellTextView.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellTextView : UITableViewCell <UITextInputTraits> {
	UITextView *textView;
	id<UITextViewDelegate> delegate;
}


@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<UITextViewDelegate> delegate;
@property (nonatomic, assign) BOOL enabled;


- (NSString *)value;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;
- (void)dismissKeyboard;
- (void)clearText;

+ (LETableViewCellTextView *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

//
//  LETableViewCellTextView.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellTextView : UITableViewCell <UITextInputTraits> {
	UILabel *label;
	UITextView *textView;
	id<UITextViewDelegate> delegate;
}


@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, assign) id<UITextViewDelegate> delegate;


- (NSString *)value;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

+ (LETableViewCellTextView *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

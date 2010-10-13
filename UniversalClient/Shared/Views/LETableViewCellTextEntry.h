//
//  LETableViewCellTextEntry.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellTextEntry : UITableViewCell <UITextInputTraits> {
	UILabel *label;
	UITextField *textField;
	id<UITextFieldDelegate> delegate;
}


@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;
@property (nonatomic, assign) BOOL enabled;


- (NSString *)value;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (void)dismissKeyboard;
- (void)clearText;


//+ (LETableViewCellTextEntry *)getCellWithNibForTableView:(UITableView *)tableView;
+ (LETableViewCellTextEntry *)getCellForTableView:(UITableView *)tableView;
+ (LETableViewCellTextEntry *)getCellForTableView:(UITableView *)tableView includeToolbar:(BOOL)includeToolbar;
+ (LETableViewCellTextEntry *)getCellForTableView:(UITableView *)tableView includeToolbar:(BOOL)includeToolbar isOptional:(BOOL)isOptional;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

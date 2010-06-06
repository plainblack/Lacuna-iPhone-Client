//
//  LETableViewCellTextView.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellTextView.h"
#import "LEMacros.h"


@implementation LETableViewCellTextView


@synthesize label;
@synthesize textView;
@dynamic delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	self.label = nil;
	self.textView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextInputTraits

- (UITextAutocapitalizationType)autocapitalizationType {
	return self.textView.autocapitalizationType;
}


- (void)setAutocapitalizationType:(UITextAutocapitalizationType) type {
	self.textView.autocapitalizationType = type;
}


- (UITextAutocorrectionType)autocorrectionType {
	return self.textView.autocorrectionType;
}


- (void)setAutocorrectionType:(UITextAutocorrectionType) type {
	self.textView.autocorrectionType = type;
}


- (BOOL)enablesReturnKeyAutomatically {
	return self.textView.enablesReturnKeyAutomatically;
}


- (void)setEnablesReturnKeyAutomatically:(BOOL) value {
	self.textView.enablesReturnKeyAutomatically = value;
}


- (UIKeyboardAppearance)keyboardAppearance {
	return self.textView.keyboardAppearance;
}


- (void)setKeyboardAppearance:(UIKeyboardAppearance) value {
	self.textView.keyboardAppearance = value;
}


- (UIKeyboardType)keyboardType {
	return self.textView.keyboardType;
}


- (void)setKeyboardType:(UIKeyboardType) value {
	self.textView.keyboardType = value;
}


- (UIReturnKeyType)returnKeyType {
	return self.textView.returnKeyType;
}


- (void)setReturnKeyType:(UIReturnKeyType) value {
	self.textView.returnKeyType = value;
}


- (BOOL)secureTextEntry {
	return self.textView.secureTextEntry;
}


- (void)setSecureTextEntry:(BOOL) value {
	self.textView.secureTextEntry = value;
}


#pragma mark -
#pragma mark Instance Methods

- (NSString *)value {
	return self.textView.text;
}


- (void)becomeFirstResponder {
	[self.textView becomeFirstResponder];
}


- (void)resignFirstResponder {
	[self.textView resignFirstResponder];
}


- (id<UITextViewDelegate>)delegate {
	return self.textView.delegate;
}


- (void)setDelegate:(id<UITextViewDelegate>)aDelegate {
	self.textView.delegate = aDelegate;
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellTextView *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"TextEntryCell";
	
	LETableViewCellTextView *cell = (LETableViewCellTextView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellTextView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 6, 320, 31)] autorelease];
		cell.textView.textAlignment = UITextAlignmentLeft;
		cell.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.textView.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:cell.textView];
		
		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.textView.font = TEXT_ENTRY_FONT;
		cell.textView.textColor = TEXT_ENTRY_COLOR;
		
		//Set text defaults
		cell.keyboardType = UIKeyboardTypeDefault;
		cell.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.autocapitalizationType = UITextAutocapitalizationTypeNone;
		cell.enablesReturnKeyAutomatically = YES;
		cell.returnKeyType = UIReturnKeyNext;
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 176.0;
}


@end

//
//  LETableViewCellTextView.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellTextView.h"
#import	<QuartzCore/QuartzCore.h>
#import "LEMacros.h"


@implementation LETableViewCellTextView


@synthesize textView;
@dynamic delegate;
@dynamic enabled;


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


- (BOOL)becomeFirstResponder {
	return [self.textView becomeFirstResponder];
}


- (BOOL)resignFirstResponder {
	return [self.textView resignFirstResponder];
}


- (id<UITextViewDelegate>)delegate {
	return self.textView.delegate;
}


- (void)setDelegate:(id<UITextViewDelegate>)aDelegate {
	self.textView.delegate = aDelegate;
}


- (BOOL)enabled {
	return self.textView.editable;
}


- (void)setEnabled:(BOOL)inEnabled {
	if (inEnabled) {
		self.textView.backgroundColor = [UIColor whiteColor];
		self.textView.editable = YES;
	} else {
		self.textView.backgroundColor = [UIColor lightGrayColor];
		self.textView.editable = NO;
	}
}


- (void)dismissKeyboard {
	[self resignFirstResponder];
}


- (void)clearText {
	self.textView.text = @"";
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self.textView becomeFirstResponder];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellTextView *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"TextViewCell";
	
	LETableViewCellTextView *cell = (LETableViewCellTextView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellTextView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.textView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 140)] autorelease];
		cell.textView.textAlignment = NSTextAlignmentLeft;
		cell.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.textView.autocorrectionType = UITextAutocorrectionTypeYes;
		cell.textView.font = TEXT_ENTRY_FONT;
		cell.textView.textColor = TEXT_ENTRY_COLOR;
		cell.textView.backgroundColor = [UIColor whiteColor];
		cell.textView.layer.borderWidth = 1;
		cell.textView.layer.borderColor = [[UIColor grayColor] CGColor];
		cell.textView.layer.cornerRadius = 8;
		[cell.contentView addSubview:cell.textView];
		
		UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
		toolbar.center = CGPointMake(160.0f, 200.0f);
		UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:cell action:@selector(clearText)] autorelease];
		UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		UIBarButtonItem *dismissItem = [[[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:cell action:@selector(dismissKeyboard)] autorelease];
		toolbar.items = _array(clearItem, spacer, dismissItem);
		cell.textView.inputAccessoryView = toolbar;
		
		//Set text defaults
		cell.keyboardType = UIKeyboardTypeDefault;
		cell.autocorrectionType = UITextAutocorrectionTypeYes;
		cell.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		cell.enablesReturnKeyAutomatically = YES;
		cell.returnKeyType = UIReturnKeyNext;
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(callTapped:)] autorelease];
		[cell.contentView addGestureRecognizer:tapRecognizer];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 151.0;
}


@end

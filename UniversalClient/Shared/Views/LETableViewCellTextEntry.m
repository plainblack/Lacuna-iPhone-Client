//
//  LETableViewCellTextEntry.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellTextEntry.h"
#import "LEMacros.h"


@implementation LETableViewCellTextEntry


@synthesize label;
@synthesize textField;
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
	self.textField = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextInputTraits

- (UITextAutocapitalizationType)autocapitalizationType {
	return self.textField.autocapitalizationType;
}


- (void)setAutocapitalizationType:(UITextAutocapitalizationType) type {
	self.textField.autocapitalizationType = type;
}


- (UITextAutocorrectionType)autocorrectionType {
	return self.textField.autocorrectionType;
}


- (void)setAutocorrectionType:(UITextAutocorrectionType) type {
	self.textField.autocorrectionType = type;
}


- (BOOL)enablesReturnKeyAutomatically {
	return self.textField.enablesReturnKeyAutomatically;
}


- (void)setEnablesReturnKeyAutomatically:(BOOL) value {
	self.textField.enablesReturnKeyAutomatically = value;
}


- (UIKeyboardAppearance)keyboardAppearance {
	return self.textField.keyboardAppearance;
}


- (void)setKeyboardAppearance:(UIKeyboardAppearance) value {
	self.textField.keyboardAppearance = value;
}


- (UIKeyboardType)keyboardType {
	return self.textField.keyboardType;
}


- (void)setKeyboardType:(UIKeyboardType) value {
	self.textField.keyboardType = value;
}


- (UIReturnKeyType)returnKeyType {
	return self.textField.returnKeyType;
}


- (void)setReturnKeyType:(UIReturnKeyType) value {
	self.textField.returnKeyType = value;
}


- (BOOL)secureTextEntry {
	return self.textField.secureTextEntry;
}


- (void)setSecureTextEntry:(BOOL) value {
	self.textField.secureTextEntry = value;
}


#pragma mark -
#pragma mark Instance Methods

- (NSString *)value {
	return self.textField.text;
}


- (void)becomeFirstResponder {
	[self.textField becomeFirstResponder];
}


- (void)resignFirstResponder {
	[self.textField resignFirstResponder];
}


- (id<UITextFieldDelegate>)delegate {
	return self.textField.delegate;
}


- (void)setDelegate:(id<UITextFieldDelegate>)aDelegate {
	self.textField.delegate = aDelegate;
}


- (void)dismissKeyboard {
	[self resignFirstResponder];
}


- (void)clearText {
	self.textField.text = @"";
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self.textField becomeFirstResponder];
}


#pragma mark -
#pragma mark Class Methods
static NSString *CellIdentifier = @"TextEntryCell";

+ (LETableViewCellTextEntry *)getCellWithNibForTableView:(UITableView *)tableView {

	LETableViewCellTextEntry *cell = (LETableViewCellTextEntry *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//Load from NIB
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LETableViewCellTextEntry"
													 owner:nil
												   options:nil];
		cell = [nib objectAtIndex:0];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		
		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.textField.font = TEXT_ENTRY_FONT;
		cell.textField.textColor = TEXT_ENTRY_COLOR;
		
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


+ (LETableViewCellTextEntry *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"TextEntryCell";
	
	LETableViewCellTextEntry *cell = (LETableViewCellTextEntry *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellTextEntry alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = UITextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.label];
		cell.textField = [[[UITextField alloc] initWithFrame:CGRectMake(105, 6, 210, 31)] autorelease];
		cell.textField.borderStyle = UITextBorderStyleRoundedRect;
		cell.textField.textAlignment = UITextAlignmentLeft;
		cell.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[cell.contentView addSubview:cell.textField];
		
		UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
		toolbar.center = CGPointMake(160.0f, 200.0f);
		UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:cell action:@selector(clearText)] autorelease];
		UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		UIBarButtonItem *dismissItem = [[[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:cell action:@selector(dismissKeyboard)] autorelease];
		toolbar.items = _array(clearItem, spacer, dismissItem);
		cell.textField.inputAccessoryView = toolbar;

		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.textField.font = TEXT_ENTRY_FONT;
		cell.textField.textColor = TEXT_ENTRY_COLOR;
		
		//Set text defaults
		cell.keyboardType = UIKeyboardTypeDefault;
		cell.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
	return tableView.rowHeight;
}


@end

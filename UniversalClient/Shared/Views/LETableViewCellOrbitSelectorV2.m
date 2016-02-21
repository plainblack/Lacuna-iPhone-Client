//
//  LETableViewCellOribtSelector.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellOrbitSelectorV2.h"
#import "LEMacros.h"
#import "Util.h"
#import "PickNumericValueController.h"


@implementation LETableViewCellOrbitSelectorV2


@synthesize nameLabel;
@synthesize numberButton;
@synthesize viewController;
@synthesize numericValue;
@synthesize pointsDelegate;


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
	self.nameLabel = nil;
	self.numberButton = nil;
	self.viewController = nil;
	self.numericValue = nil;
	self.pointsDelegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PickNumericValueController Methods

- (void)newNumericValue:(NSDecimalNumber *)value {
	self.numericValue = value;
	[self.numberButton setTitle:[self.numericValue stringValue] forState:UIControlStateNormal];
	[self.pointsDelegate updatePoints];
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods


- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(long)index {
	if (index != [alertView cancelButtonIndex]) {
		self.numericValue = [NSDecimalNumber one];
		[self.numberButton setTitle:[self.numericValue stringValue] forState:UIControlStateNormal];
		[self.pointsDelegate updatePoints];
	}
}


#pragma mark -
#pragma mark Instance Methods

- (NSDecimalNumber *)rating {
	return self.numericValue;
}


- (void)setRating:(NSInteger)aRating {
	self.numericValue = [Util decimalFromInt:aRating];
	[self.numberButton setTitle:[self.numericValue stringValue] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)editNumericValue {
	PickNumericValueController *pickNumericValueController = [PickNumericValueController createWithDelegate:self maxValue:[NSDecimalNumber decimalNumberWithString:@"7"] hidesZero:YES showTenths:NO];
	[self.viewController presentViewController:pickNumericValueController animated:YES completion:nil];
	[pickNumericValueController setValue:self.numericValue];
	pickNumericValueController.titleLabel.text = self.nameLabel.text;
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self editNumericValue];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellOrbitSelectorV2 *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"OribtSelectorCell";
	
	LETableViewCellOrbitSelectorV2 *cell = (LETableViewCellOrbitSelectorV2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellOrbitSelectorV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 11, 175, 21)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = NSTextAlignmentRight;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.nameLabel];
		
		cell.numberButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cell.numberButton.frame = CGRectMake(203, 6, 97, 32);
		cell.numberButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.numberButton.titleLabel.font = TEXT_ENTRY_FONT;
		cell.numberButton.titleLabel.textColor = TEXT_ENTRY_COLOR;
		[cell.numberButton addTarget:cell action:@selector(editNumericValue) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:cell.numberButton];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(callTapped:)] autorelease];
		[cell.contentView addGestureRecognizer:tapRecognizer];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

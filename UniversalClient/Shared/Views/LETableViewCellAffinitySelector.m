//
//  LETableViewCellAffinitySelector.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellAffinitySelector.h"
#import "LEMacros.h"
#import "Util.h"


@interface LETableViewCellAffinitySelector (PrivateMethods)
- (void)updateValueLabel;
- (void)reallyDecreaseValue;
@end


@implementation LETableViewCellAffinitySelector


@synthesize nameLabel;
@synthesize valueLabel;
@synthesize minusButton;
@synthesize plusButton;
@synthesize pointsDelegate;
@synthesize value;


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
	self.valueLabel = nil;
	self.minusButton = nil;
	self.plusButton = nil;
	self.value = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(int)index {
	if (index != [alertView cancelButtonIndex]) {
		[self reallyDecreaseValue];
	}
}


#pragma mark -
#pragma mark Instance Methods

- (NSDecimalNumber *)rating {
	return self.value;
}


- (void)setRating:(NSInteger)aRating {
	self.value = [Util decimalFromInt:aRating];
	[self updateValueLabel];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)decreaseValue {
	if (_intv(self.value) == 2) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Are you sure"
													 message:@"Setting an affinity to 1 puts you are a significant disadvantage and should only be done by expert players."
													delegate:self
										   cancelButtonTitle:@"Cancel"
										   otherButtonTitles:@"OK", nil];
		[av show];
	} else {
		[self reallyDecreaseValue];
	}
}


- (IBAction)increaseValue {
	self.value = [Util decimalFromInt:([self.value intValue] + 1)];
	[self.pointsDelegate updatePoints:1];
	[self updateValueLabel];
}


#pragma mark -
#pragma mark Private Methods


- (void)updateValueLabel {
	self.valueLabel.text = [value stringValue];
	[self.minusButton setEnabled:(_intv(self.value) > 1)];
	[self.plusButton setEnabled:(_intv(self.value) < 7)];
}


- (void)reallyDecreaseValue {
	self.value = [Util decimalFromInt:([self.value intValue] - 1)];
	[self.pointsDelegate updatePoints:-1];
	[self updateValueLabel];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellAffinitySelector *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"AffinitySelectorCell";
	
	LETableViewCellAffinitySelector *cell = (LETableViewCellAffinitySelector *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellAffinitySelector alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 11, 175, 21)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = UITextAlignmentRight;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.nameLabel];
		
		cell.valueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(245, 11, 13, 21)] autorelease];
		cell.valueLabel.backgroundColor = [UIColor clearColor];
		cell.valueLabel.textAlignment = UITextAlignmentLeft;
		cell.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.valueLabel.font = TEXT_FONT;
		cell.valueLabel.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.valueLabel];
		
		cell.minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cell.minusButton.frame = CGRectMake(203, 4, 34, 35);
		cell.minusButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.minusButton setTitle:@"-" forState:UIControlStateNormal];
		[cell.minusButton addTarget:cell action:@selector(decreaseValue) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:cell.minusButton];
		
		cell.plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cell.plusButton.frame = CGRectMake(266, 4, 34, 35);
		cell.plusButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.plusButton setTitle:@"+" forState:UIControlStateNormal];
		[cell.plusButton addTarget:cell action:@selector(increaseValue) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:cell.plusButton];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

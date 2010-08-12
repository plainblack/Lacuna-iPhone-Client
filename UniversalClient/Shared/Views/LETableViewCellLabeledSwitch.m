//
//  LETableViewCellLabeledSwitch.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellLabeledSwitch.h"
#import "LEMacros.h"


@implementation LETableViewCellLabeledSwitch


@synthesize label;
@synthesize selectedSwitch;
@synthesize isSelected;


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
	self.selectedSwitch = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)switchChanged {
	self.isSelected = self.selectedSwitch.on;
}


#pragma mark --
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self.selectedSwitch setOn:!self.selectedSwitch.on animated:YES];
	self.isSelected = self.selectedSwitch.on;
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellLabeledSwitch *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"LabeledSwitchCell";
	
	LETableViewCellLabeledSwitch *cell = (LETableViewCellLabeledSwitch *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellLabeledSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 12, 178, 21)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = UITextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.label.font = TEXT_FONT;
		cell.label.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.label];
		
		cell.selectedSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(206, 9, 94, 27)] autorelease];
		cell.selectedSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.selectedSwitch addTarget:cell action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview:cell.selectedSwitch];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(callTapped:)] autorelease];
		[cell.contentView addGestureRecognizer:tapRecognizer];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

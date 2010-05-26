//
//  LETableViewCellOrbitSelector.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellOrbitSelector.h"
#import "LEMacros.h"


@implementation LETableViewCellOrbitSelector


@synthesize label;
@synthesize selectedSwitch;
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
	self.label = nil;
	self.selectedSwitch = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (BOOL)isSelected {
	return self.selectedSwitch.on;
}


#pragma mark -
#pragma mark Callbacks


- (void)selectionChanged {
	if (self.selectedSwitch.on) {
		[self.pointsDelegate updatePoints:1];
	} else {
		[self.pointsDelegate updatePoints:-1];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellOrbitSelector *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"OrbitSelectorCell";
	
	LETableViewCellOrbitSelector *cell = (LETableViewCellOrbitSelector *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellOrbitSelector alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
		[cell.selectedSwitch addTarget:cell action:@selector(selectionChanged) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview:cell.selectedSwitch];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

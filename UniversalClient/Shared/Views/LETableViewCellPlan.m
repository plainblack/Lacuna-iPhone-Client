//
//  LETableViewCellPlan.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellPlan.h"
#import "LEMacros.h"
#import "Plan.h"


@implementation LETableViewCellPlan


@synthesize name;
@synthesize buildLevel;


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
	self.name = nil;
	self.buildLevel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setPlan:(Plan *)plan {
	self.name.text = plan.name;
	if (plan.extraBuildLevel) {
		self.buildLevel.text = [NSString stringWithFormat:@"Builds level %@, upgrades to %@", [plan.buildLevel stringValue], [plan.extraBuildLevel stringValue]];
	} else {
		self.buildLevel.text = [NSString stringWithFormat:@"Builds level %@", [plan.buildLevel stringValue]];
	}

}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellPlan *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable {
	static NSString *SelectableCellIdentifier = @"PlanCellSelectable";
	static NSString *CellIdentifier = @"PlanCell";
	
	NSString *cellIdentifier;
	if (isSelectable) {
		cellIdentifier = SelectableCellIdentifier;
	} else {
		cellIdentifier = CellIdentifier;
	}
	
	LETableViewCellPlan *cell = (LETableViewCellPlan *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellPlan alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.name = [[[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 20)] autorelease];
		cell.name.backgroundColor = [UIColor clearColor];
		cell.name.textAlignment = NSTextAlignmentLeft;
		cell.name.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.name.font = BUTTON_TEXT_FONT;
		[cell.contentView addSubview:cell.name];

		cell.buildLevel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 26, 300, 20)] autorelease];
		cell.buildLevel.backgroundColor = [UIColor clearColor];
		cell.buildLevel.textAlignment = NSTextAlignmentLeft;
		cell.buildLevel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.buildLevel.font = TEXT_FONT;
		[cell.contentView addSubview:cell.buildLevel];
		
		if (isSelectable) {
			cell.name.textColor = BUTTON_TEXT_COLOR;
			cell.buildLevel.textColor = BUTTON_TEXT_COLOR;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		} else {
			cell.name.textColor = TEXT_COLOR;
			cell.buildLevel.textColor = TEXT_COLOR;
		}
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 52.0f;
}


@end

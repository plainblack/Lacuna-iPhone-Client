//
//  LETableViewCellPlanLevel.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LETableViewCellPlanLevel.h"
#import "LEMacros.h"
#import "Util.h"


@interface LETableViewCellPlanLevel (PrivateMethods)
- (void)setCostLabel:(UILabel *)costLabel cost:(NSDecimalNumber *)cost;
@end


@implementation LETableViewCellPlanLevel


@synthesize planLevelLabel;
@synthesize energyCostLabel;
@synthesize foodCostLabel;
@synthesize timeCostLabel;
@synthesize oreCostLabel;
@synthesize wasteCostLabel;
@synthesize waterCostLabel;


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
    self.planLevelLabel  = nil;
	self.energyCostLabel = nil;
	self.foodCostLabel = nil;
	self.timeCostLabel = nil;
	self.oreCostLabel = nil;
	self.wasteCostLabel = nil;
	self.waterCostLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setPlanLevel:(NSMutableDictionary *)planLevel {
    self.planLevelLabel.text = [NSString stringWithFormat:@"Level %@", [planLevel objectForKey:@"level"]];
	[self setCostLabel:energyCostLabel cost:[Util asNumber:[planLevel objectForKey:@"energy"]]];
	[self setCostLabel:foodCostLabel cost:[Util asNumber:[planLevel objectForKey:@"food"]]];
	self.timeCostLabel.text = [Util prettyDuration:_intv([planLevel objectForKey:@"time"])];
	[self setCostLabel:oreCostLabel cost:[Util asNumber:[planLevel objectForKey:@"ore"]]];
	[self setCostLabel:wasteCostLabel cost:[Util asNumber:[planLevel objectForKey:@"waste"]]];
	[self setCostLabel:waterCostLabel cost:[Util asNumber:[planLevel objectForKey:@"water"]]];
}


#pragma mark -
#pragma mark Private Methods


- (void)setCostLabel:(UILabel *)costLabel cost:(NSDecimalNumber *)cost {
	costLabel.text = [NSString stringWithFormat:@"%@", [Util prettyNSDecimalNumber:cost]];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellPlanLevel *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"PlanLevelCell";
	
	LETableViewCellPlanLevel *cell = (LETableViewCellPlanLevel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellPlanLevel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.planLevelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 22)] autorelease];
		cell.planLevelLabel.backgroundColor = [UIColor clearColor];
		cell.planLevelLabel.textAlignment = NSTextAlignmentLeft;
		cell.planLevelLabel.font = BUTTON_TEXT_FONT;
		cell.planLevelLabel.textColor = BUTTON_TEXT_COLOR;
		cell.planLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.planLevelLabel];

		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ENERGY_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.energyCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 23, 70, 20)] autorelease];
		cell.energyCostLabel.backgroundColor = [UIColor clearColor];
		cell.energyCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.energyCostLabel.font = TEXT_SMALL_FONT;
		cell.energyCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = FOOD_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.foodCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 23, 70, 20)] autorelease];
		cell.foodCostLabel.backgroundColor = [UIColor clearColor];
		cell.foodCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.foodCostLabel.font = TEXT_SMALL_FONT;
		cell.foodCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodCostLabel];
        
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ORE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.oreCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 23, 70, 20)] autorelease];
		cell.oreCostLabel.backgroundColor = [UIColor clearColor];
		cell.oreCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.oreCostLabel.font = TEXT_SMALL_FONT;
		cell.oreCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 50, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = TIME_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.timeCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(38, 51, 66, 20)] autorelease];
		cell.timeCostLabel.backgroundColor = [UIColor clearColor];
		cell.timeCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.timeCostLabel.font = TEXT_SMALL_FONT;
		cell.timeCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.timeCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.timeCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 50, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WASTE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.wasteCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 51, 70, 20)] autorelease];
		cell.wasteCostLabel.backgroundColor = [UIColor clearColor];
		cell.wasteCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.wasteCostLabel.font = TEXT_SMALL_FONT;
		cell.wasteCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 50, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WATER_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.waterCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 51, 70, 20)] autorelease];
		cell.waterCostLabel.backgroundColor = [UIColor clearColor];
		cell.waterCostLabel.textAlignment = NSTextAlignmentLeft;
		cell.waterCostLabel.font = TEXT_SMALL_FONT;
		cell.waterCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterCostLabel];
        
		//Set Cell Defaults
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 80.0;
}


@end

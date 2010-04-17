//
//  LETableViewCellCost.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellCost.h"
#import "LEMacros.h"
#import "Util.h"


@interface LETableViewCellCost (PrivateMethods)
- (void)setCostLabel:(UILabel *)costLabel cost:(NSNumber *)cost;
@end


@implementation LETableViewCellCost


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


- (void)setEnergyCost:(NSNumber *)cost {
	[self setCostLabel:energyCostLabel cost:cost];
}


- (void)setFoodCost:(NSNumber *)cost {
	[self setCostLabel:foodCostLabel cost:cost];
}


- (void)setTimeCost:(NSNumber *)cost {
	//[self setCostLabel:timeCostLabel cost:cost];
	self.timeCostLabel.text = [Util prettyDuration:intv_(cost)];
}


- (void)setOreCost:(NSNumber *)cost {
	[self setCostLabel:oreCostLabel cost:cost];
}


- (void)setWasteCost:(NSNumber *)cost {
	[self setCostLabel:wasteCostLabel cost:cost];
}


- (void)setWaterCost:(NSNumber *)cost {
	[self setCostLabel:waterCostLabel cost:cost];
}


#pragma mark -
#pragma mark Private Methods


- (void)setCostLabel:(UILabel *)costLabel cost:(NSNumber *)cost {
	costLabel.text = [NSString stringWithFormat:@"%@", cost];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellCost *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"CostCell";
	
	LETableViewCellCost *cell = (LETableViewCellCost *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellCost alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/energy.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.energyCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 8, 70, 20)] autorelease];
		cell.energyCostLabel.backgroundColor = [UIColor clearColor];
		cell.energyCostLabel.textAlignment = UITextAlignmentLeft;
		cell.energyCostLabel.font = TEXT_SMALL_FONT;
		cell.energyCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/food.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.foodCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 8, 70, 20)] autorelease];
		cell.foodCostLabel.backgroundColor = [UIColor clearColor];
		cell.foodCostLabel.textAlignment = UITextAlignmentLeft;
		cell.foodCostLabel.font = TEXT_SMALL_FONT;
		cell.foodCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodCostLabel];

		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/ore.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.oreCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 8, 70, 20)] autorelease];
		cell.oreCostLabel.backgroundColor = [UIColor clearColor];
		cell.oreCostLabel.textAlignment = UITextAlignmentLeft;
		cell.oreCostLabel.font = TEXT_SMALL_FONT;
		cell.oreCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/time.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.timeCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 36, 70, 20)] autorelease];
		cell.timeCostLabel.backgroundColor = [UIColor clearColor];
		cell.timeCostLabel.textAlignment = UITextAlignmentLeft;
		cell.timeCostLabel.font = TEXT_SMALL_FONT;
		cell.timeCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.timeCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.timeCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/waste.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.wasteCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 36, 70, 20)] autorelease];
		cell.wasteCostLabel.backgroundColor = [UIColor clearColor];
		cell.wasteCostLabel.textAlignment = UITextAlignmentLeft;
		cell.wasteCostLabel.font = TEXT_SMALL_FONT;
		cell.wasteCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteCostLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/water.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.waterCostLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 36, 70, 20)] autorelease];
		cell.waterCostLabel.backgroundColor = [UIColor clearColor];
		cell.waterCostLabel.textAlignment = UITextAlignmentLeft;
		cell.waterCostLabel.font = TEXT_SMALL_FONT;
		cell.waterCostLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterCostLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterCostLabel];

		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 65.0;
}


@end

//
//  LETableViewCellCurrentResources.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellCurrentResources.h"
#import "LEMacros.h"
#import "Util.h"


@interface LETableViewCellCurrentResources (PrivateMethods)


- (void)setTotalLabel:(UILabel *)totalLabel current:(NSNumber *)current capacity:(NSNumber *)capacity;
- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSNumber *)perHour;
- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSNumber *)perHour;


@end


@implementation LETableViewCellCurrentResources


@synthesize energyTotalLabel;
@synthesize energyPerHourLabel;
@synthesize foodTotalLabel;
@synthesize foodPerHourLabel;
@synthesize happinessTotalLabel;
@synthesize happinessPerHourLabel;
@synthesize oreTotalLabel;
@synthesize orePerHourLabel;
@synthesize wasteTotalLabel;
@synthesize wastePerHourLabel;
@synthesize waterTotalLabel;
@synthesize waterPerHourLabel;


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
	self.energyTotalLabel = nil;
	self.energyPerHourLabel = nil;
	self.foodTotalLabel = nil;
	self.foodPerHourLabel = nil;
	self.happinessTotalLabel = nil;
	self.happinessPerHourLabel = nil;
	self.oreTotalLabel = nil;
	self.orePerHourLabel = nil;
	self.wasteTotalLabel = nil;
	self.wastePerHourLabel = nil;
	self.waterTotalLabel = nil;
	self.waterPerHourLabel = nil;

    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setEnergyCurrent:(NSNumber *)current capacity:(NSNumber *)capacity perHour:(NSNumber *)perHour {
	[self setTotalLabel:energyTotalLabel current:current capacity:capacity];
	[self setNormalPerHourLabel:energyPerHourLabel perHour:perHour];
}


- (void)setFoodCurrent:(NSNumber *)current capacity:(NSNumber *)capacity perHour:(NSNumber *)perHour {
	[self setTotalLabel:foodTotalLabel current:current capacity:capacity];
	[self setNormalPerHourLabel:foodPerHourLabel perHour:perHour];
}


- (void)setHappinessCurrent:(NSNumber *)current perHour:(NSNumber *)perHour {
	self.happinessTotalLabel.text = [NSString stringWithFormat:@"%@", [Util prettyNumber:current]];
	[self setNormalPerHourLabel:happinessPerHourLabel perHour:perHour];
}


- (void)setOreCurrent:(NSNumber *)current capacity:(NSNumber *)capacity perHour:(NSNumber *)perHour {
	[self setTotalLabel:oreTotalLabel current:current capacity:capacity];
	[self setNormalPerHourLabel:orePerHourLabel perHour:perHour];
}


- (void)setWasteCurrent:(NSNumber *)current capacity:(NSNumber *)capacity perHour:(NSNumber *)perHour {
	[self setTotalLabel:wasteTotalLabel current:current capacity:capacity];
	[self setNormalPerHourLabel:wastePerHourLabel perHour:perHour];
	//[self setOppositePerHourLabel:wastePerHourLabel perHour:perHour];
}


- (void)setWaterCurrent:(NSNumber *)current capacity:(NSNumber *)capacity perHour:(NSNumber *)perHour {
	[self setTotalLabel:waterTotalLabel current:current capacity:capacity];
	[self setNormalPerHourLabel:waterPerHourLabel perHour:perHour];
}


#pragma mark -
#pragma mark Private Methods

- (void)setTotalLabel:(UILabel *)totalLabel current:(NSNumber *)current capacity:(NSNumber *)capacity {
	totalLabel.text = [NSString stringWithFormat:@"%@/%@", [Util prettyNumber:current], [Util prettyNumber:capacity]];
	if (intv_(current) == intv_(capacity)) {
		totalLabel.textColor = [UIColor redColor];
	} else {
		totalLabel.textColor = [UIColor blackColor];
	}

}


- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSNumber *)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%@/hr", [Util prettyNumber:perHour]];
	if ([perHour intValue] < 0) {
		perHourLabel.textColor = [UIColor redColor];
	} else {
		perHourLabel.textColor = [UIColor blackColor];
	}
}


- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSNumber *)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%@/hr", [Util prettyNumber:perHour]];
	if ([perHour intValue] < 0) {
		perHourLabel.textColor = [UIColor blackColor];
	} else {
		perHourLabel.textColor = [UIColor redColor];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellCurrentResources *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"BodyCell";
	
	LETableViewCellCurrentResources *cell = (LETableViewCellCurrentResources *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellCurrentResources alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		/*
		 * ENERGY
		 */
		//TOTAL
		cell.energyTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 10, 74, 20)] autorelease];
		cell.energyTotalLabel.backgroundColor = [UIColor clearColor];
		cell.energyTotalLabel.textAlignment = UITextAlignmentRight;
		cell.energyTotalLabel.font = TEXT_SMALL_FONT;
		cell.energyTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyTotalLabel];
		//ICON
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(83, 9, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/energy.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.energyPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(108, 10, 45, 20)] autorelease];
		cell.energyPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.energyPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.energyPerHourLabel.font = TEXT_SMALL_FONT;
		cell.energyPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyPerHourLabel];
		
		/*
		 * FOOD
		 */
		//TOTAL
		cell.foodTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(162, 10, 74, 20)] autorelease];
		cell.foodTotalLabel.backgroundColor = [UIColor clearColor];
		cell.foodTotalLabel.textAlignment = UITextAlignmentRight;
		cell.foodTotalLabel.font = TEXT_SMALL_FONT;
		cell.foodTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(239, 9, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/food.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.foodPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(264, 10, 45, 20)] autorelease];
		cell.foodPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.foodPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.foodPerHourLabel.font = TEXT_SMALL_FONT;
		cell.foodPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodPerHourLabel];
		
		/*
		 * HAPPINESS
		 */
		//TOTAL
		cell.happinessTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 39, 74, 20)] autorelease];
		cell.happinessTotalLabel.backgroundColor = [UIColor clearColor];
		cell.happinessTotalLabel.textAlignment = UITextAlignmentRight;
		cell.happinessTotalLabel.font = TEXT_SMALL_FONT;
		cell.happinessTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(83, 38, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/happiness.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.happinessPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(108, 39, 45, 20)] autorelease];
		cell.happinessPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.happinessPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.happinessPerHourLabel.font = TEXT_SMALL_FONT;
		cell.happinessPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessPerHourLabel];
		
		/*
		 * ORE
		 */
		//TOTAL
		cell.oreTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(162, 39, 74, 20)] autorelease];
		cell.oreTotalLabel.backgroundColor = [UIColor clearColor];
		cell.oreTotalLabel.textAlignment = UITextAlignmentRight;
		cell.oreTotalLabel.font = TEXT_SMALL_FONT;
		cell.oreTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(239, 38, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/ore.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.orePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(264, 39, 45, 20)] autorelease];
		cell.orePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.orePerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.orePerHourLabel.font = TEXT_SMALL_FONT;
		cell.orePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.orePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.orePerHourLabel];
		
		/*
		 * WASTE
		 */
		//TOTAL
		cell.wasteTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 69, 74, 20)] autorelease];
		cell.wasteTotalLabel.backgroundColor = [UIColor clearColor];
		cell.wasteTotalLabel.textAlignment = UITextAlignmentRight;
		cell.wasteTotalLabel.font = TEXT_SMALL_FONT;
		cell.wasteTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(83, 68, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/waste.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.wastePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(108, 69, 45, 20)] autorelease];
		cell.wastePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.wastePerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.wastePerHourLabel.font = TEXT_SMALL_FONT;
		cell.wastePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.wastePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wastePerHourLabel];
		
		/*
		 * WATER
		 */
		//TOTAL
		cell.waterTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(162, 69, 74, 20)] autorelease];
		cell.waterTotalLabel.backgroundColor = [UIColor clearColor];
		cell.waterTotalLabel.textAlignment = UITextAlignmentRight;
		cell.waterTotalLabel.font = TEXT_SMALL_FONT;
		cell.waterTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(239, 68, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/water.png"];
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.waterPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(264, 69, 45, 20)] autorelease];
		cell.waterPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.waterPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.waterPerHourLabel.font = TEXT_SMALL_FONT;
		cell.waterPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterPerHourLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 100.0;
}


@end

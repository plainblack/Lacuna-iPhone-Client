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


- (void)setTotalLabel:(UILabel *)totalLabel current:(NSDecimalNumber *)current capacity:(NSDecimalNumber *)capacity;
- (void)setPerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour;


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


- (void)showBodyData:(Body *)body {
	[self setTotalLabel:energyTotalLabel current:body.energy.current capacity:body.energy.max];
	[self setPerHourLabel:energyPerHourLabel perHour:body.energy.perHour];

	[self setTotalLabel:foodTotalLabel current:body.food.current capacity:body.food.max];
	[self setPerHourLabel:foodPerHourLabel perHour:body.food.perHour];

	self.happinessTotalLabel.text = [NSString stringWithFormat:@"%@", [Util prettyNSDecimalNumber:body.happiness.current]];
	[self setPerHourLabel:happinessPerHourLabel perHour:body.happiness.perHour];

	[self setTotalLabel:oreTotalLabel current:body.ore.current capacity:body.ore.max];
	[self setPerHourLabel:orePerHourLabel perHour:body.ore.perHour];

	[self setTotalLabel:wasteTotalLabel current:body.waste.current capacity:body.waste.max];
	[self setPerHourLabel:wastePerHourLabel perHour:body.waste.perHour];

	[self setTotalLabel:waterTotalLabel current:body.water.current capacity:body.water.max];
	[self setPerHourLabel:waterPerHourLabel perHour:body.water.perHour];
}


#pragma mark -
#pragma mark Private Methods

- (void)setTotalLabel:(UILabel *)totalLabel current:(NSDecimalNumber *)current capacity:(NSDecimalNumber *)capacity {
	totalLabel.text = [NSString stringWithFormat:@"%@/%@", [Util prettyNSDecimalNumber:current], [Util prettyNSDecimalNumber:capacity]];
	if ([current compare:capacity] == NSOrderedSame) {
		totalLabel.textColor = WARNING_COLOR;
	} else {
		totalLabel.textColor = TEXT_SMALL_COLOR;
	}

}


- (void)setPerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%@/hr", [Util prettyNSDecimalNumber:perHour]];
	if (_intv(perHour) < 0) {
		perHourLabel.textColor = WARNING_COLOR;
	} else {
		perHourLabel.textColor = TEXT_SMALL_COLOR;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellCurrentResources *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"CurrentResourceCell";
	
	LETableViewCellCurrentResources *cell = (LETableViewCellCurrentResources *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellCurrentResources alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		/*
		 * ENERGY
		 */
		//TOTAL
		cell.energyTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 74, 20)] autorelease];
		cell.energyTotalLabel.backgroundColor = [UIColor clearColor];
		cell.energyTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.energyTotalLabel.font = TEXT_SMALL_FONT;
		cell.energyTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyTotalLabel];
		//ICON
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(78, 9, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ENERGY_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.energyPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(101, 10, 45, 20)] autorelease];
		cell.energyPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.energyPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.energyPerHourLabel.font = TEXT_SMALL_FONT;
		cell.energyPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyPerHourLabel];
		
		/*
		 * FOOD
		 */
		//TOTAL
		cell.foodTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165, 10, 74, 20)] autorelease];
		cell.foodTotalLabel.backgroundColor = [UIColor clearColor];
		cell.foodTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.foodTotalLabel.font = TEXT_SMALL_FONT;
		cell.foodTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(242, 9, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = FOOD_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.foodPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(267, 10, 45, 20)] autorelease];
		cell.foodPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.foodPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.foodPerHourLabel.font = TEXT_SMALL_FONT;
		cell.foodPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodPerHourLabel];
		
		/*
		 * HAPPINESS
		 */
		//TOTAL
		cell.happinessTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 39, 74, 20)] autorelease];
		cell.happinessTotalLabel.backgroundColor = [UIColor clearColor];
		cell.happinessTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.happinessTotalLabel.font = TEXT_SMALL_FONT;
		cell.happinessTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(78, 38, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = HAPPINESS_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.happinessPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(101, 39, 45, 20)] autorelease];
		cell.happinessPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.happinessPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.happinessPerHourLabel.font = TEXT_SMALL_FONT;
		cell.happinessPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessPerHourLabel];
		
		/*
		 * ORE
		 */
		//TOTAL
		cell.oreTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165, 39, 74, 20)] autorelease];
		cell.oreTotalLabel.backgroundColor = [UIColor clearColor];
		cell.oreTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.oreTotalLabel.font = TEXT_SMALL_FONT;
		cell.oreTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(242, 38, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ORE_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.orePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(267, 39, 45, 20)] autorelease];
		cell.orePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.orePerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.orePerHourLabel.font = TEXT_SMALL_FONT;
		cell.orePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.orePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.orePerHourLabel];
		
		/*
		 * WASTE
		 */
		//TOTAL
		cell.wasteTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 69, 74, 20)] autorelease];
		cell.wasteTotalLabel.backgroundColor = [UIColor clearColor];
		cell.wasteTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.wasteTotalLabel.font = TEXT_SMALL_FONT;
		cell.wasteTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(78, 68, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WASTE_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.wastePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(101, 69, 45, 20)] autorelease];
		cell.wastePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.wastePerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.wastePerHourLabel.font = TEXT_SMALL_FONT;
		cell.wastePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.wastePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wastePerHourLabel];
		
		/*
		 * WATER
		 */
		//TOTAL
		cell.waterTotalLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165, 69, 74, 20)] autorelease];
		cell.waterTotalLabel.backgroundColor = [UIColor clearColor];
		cell.waterTotalLabel.textAlignment = NSTextAlignmentRight;
		cell.waterTotalLabel.font = TEXT_SMALL_FONT;
		cell.waterTotalLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterTotalLabel];
		//ICON
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(242, 68, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WATER_ICON;
		[cell.contentView addSubview:tmpImageView];
		//PER HOUR
		cell.waterPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(267, 69, 45, 20)] autorelease];
		cell.waterPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.waterPerHourLabel.textAlignment = NSTextAlignmentLeft;
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

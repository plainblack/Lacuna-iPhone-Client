//
//  LETableViewCellBuildingStats.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildingStats.h"
#import "LEMacros.h"
#import "Util.h"


@interface LETableViewCellBuildingStats (PrivateMethods)
- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour;
- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour;
@end


@implementation LETableViewCellBuildingStats


@synthesize energyPerHourLabel;
@synthesize foodPerHourLabel;
@synthesize happinessPerHourLabel;
@synthesize orePerHourLabel;
@synthesize wastePerHourLabel;
@synthesize waterPerHourLabel;
@synthesize buildingBackgroundImageView;
@synthesize buildingImageView;
@synthesize buildingLevelLabel;


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
	self.energyPerHourLabel = nil;
	self.foodPerHourLabel = nil;
	self.happinessPerHourLabel = nil;
	self.orePerHourLabel = nil;
	self.wastePerHourLabel = nil;
	self.waterPerHourLabel = nil;
	self.buildingBackgroundImageView = nil;
	self.buildingImageView = nil;
	self.buildingLevelLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setBuildingBackgroundImage:(UIImage *)buildingBackgroundImage {
	self.buildingBackgroundImageView.image = buildingBackgroundImage;
}


- (void)setBuildingImage:(UIImage *)buildingImage {
	self.buildingImageView.image = buildingImage;
}


- (void)setBuildingLevel:(NSDecimalNumber *)level {
	self.buildingLevelLabel.text = [NSString stringWithFormat:@"Level %@", level];
}


- (void)setEnergyPerHour:(NSDecimalNumber *)perHour {
	[self setNormalPerHourLabel:energyPerHourLabel perHour:perHour];
}


- (void)setFoodPerHour:(NSDecimalNumber *)perHour {
	[self setNormalPerHourLabel:foodPerHourLabel perHour:perHour];
}


- (void)setHappinessPerHour:(NSDecimalNumber *)perHour {
	[self setNormalPerHourLabel:happinessPerHourLabel perHour:perHour];
}


- (void)setOrePerHour:(NSDecimalNumber *)perHour {
	[self setNormalPerHourLabel:orePerHourLabel perHour:perHour];
}


- (void)setWastePerHour:(NSDecimalNumber *)perHour {
	[self setOppositePerHourLabel:wastePerHourLabel perHour:perHour];
}


- (void)setWaterPerHour:(NSDecimalNumber *)perHour {
	[self setNormalPerHourLabel:waterPerHourLabel perHour:perHour];
}


- (void)setResourceGeneration:(ResourceGeneration *)resourceGeneration {
	[self setNormalPerHourLabel:energyPerHourLabel perHour:resourceGeneration.energy];
	[self setNormalPerHourLabel:foodPerHourLabel perHour:resourceGeneration.food];
	[self setNormalPerHourLabel:happinessPerHourLabel perHour:resourceGeneration.happiness];
	[self setNormalPerHourLabel:orePerHourLabel perHour:resourceGeneration.ore];
	[self setOppositePerHourLabel:wastePerHourLabel perHour:resourceGeneration.waste];
	[self setNormalPerHourLabel:waterPerHourLabel perHour:resourceGeneration.water];
}


#pragma mark -
#pragma mark Private Methods


- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%@/hr", [Util prettyNSDecimalNumber:perHour]];
	if (perHour < 0) {
		perHourLabel.textColor = WARNING_COLOR;
	} else {
		perHourLabel.textColor = TEXT_SMALL_COLOR;
	}
}


- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSDecimalNumber *)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%@/hr", [Util prettyNSDecimalNumber:perHour]];
	if (perHour <= 0) {
		perHourLabel.textColor = TEXT_SMALL_COLOR;
	} else {
		perHourLabel.textColor = WARNING_COLOR;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildingStats *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"BuildingStatsCell";
	
	LETableViewCellBuildingStats *cell = (LETableViewCellBuildingStats *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBuildingStats alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.buildingBackgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.buildingBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingBackgroundImageView];
		cell.buildingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.buildingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingImageView];
		
		cell.buildingLevelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, 10, 200, 22)] autorelease];
		cell.buildingLevelLabel.backgroundColor = [UIColor clearColor];
		cell.buildingLevelLabel.textAlignment = NSTextAlignmentLeft;
		cell.buildingLevelLabel.font = TEXT_FONT;
		cell.buildingLevelLabel.textColor = TEXT_COLOR;
		cell.buildingLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingLevelLabel];
		
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(125, 34, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ENERGY_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.energyPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, 35, 65, 20)] autorelease];
		cell.energyPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.energyPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.energyPerHourLabel.font = TEXT_SMALL_FONT;
		cell.energyPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(210, 34, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = FOOD_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.foodPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(235, 35, 65, 20)] autorelease];
		cell.foodPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.foodPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.foodPerHourLabel.font = TEXT_SMALL_FONT;
		cell.foodPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(125, 62, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ORE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.orePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, 63, 65, 20)] autorelease];
		cell.orePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.orePerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.orePerHourLabel.font = TEXT_SMALL_FONT;
		cell.orePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.orePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.orePerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(210, 62, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WATER_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.waterPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(235, 63, 65, 20)] autorelease];
		cell.waterPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.waterPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.waterPerHourLabel.font = TEXT_SMALL_FONT;
		cell.waterPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(125, 90, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WASTE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.wastePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, 91, 65, 20)] autorelease];
		cell.wastePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.wastePerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.wastePerHourLabel.font = TEXT_SMALL_FONT;
		cell.wastePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.wastePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wastePerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(210, 90, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = HAPPINESS_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.happinessPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(235, 91, 65, 20)] autorelease];
		cell.happinessPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.happinessPerHourLabel.textAlignment = NSTextAlignmentLeft;
		cell.happinessPerHourLabel.font = TEXT_SMALL_FONT;
		cell.happinessPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessPerHourLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 120.0;
}


@end

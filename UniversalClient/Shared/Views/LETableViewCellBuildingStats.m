//
//  LETableViewCellBuildingStats.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildingStats.h"
#import "LEMacros.h"


@interface LETableViewCellBuildingStats (PrivateMethods)
- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSInteger)perHour;
- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSInteger)perHour;
@end


@implementation LETableViewCellBuildingStats


@synthesize energyPerHourLabel;
@synthesize foodPerHourLabel;
@synthesize happinessPerHourLabel;
@synthesize orePerHourLabel;
@synthesize wastePerHourLabel;
@synthesize waterPerHourLabel;
@synthesize buildingImageView;
@synthesize buildingNameAndLevelLabel;


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
	self.buildingImageView = nil;
	self.buildingNameAndLevelLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setEnergyPerHour:(NSNumber *)perHour {
	[self setNormalPerHourLabel:energyPerHourLabel perHour:_intv(perHour)];
}


- (void)setFoodPerHour:(NSNumber *)perHour {
	[self setNormalPerHourLabel:foodPerHourLabel perHour:_intv(perHour)];
}


- (void)setHappinessPerHour:(NSNumber *)perHour {
	[self setNormalPerHourLabel:happinessPerHourLabel perHour:_intv(perHour)];
}


- (void)setOrePerHour:(NSNumber *)perHour {
	[self setNormalPerHourLabel:orePerHourLabel perHour:_intv(perHour)];
}


- (void)setWastePerHour:(NSNumber *)perHour {
	[self setOppositePerHourLabel:wastePerHourLabel perHour:_intv(perHour)];
}


- (void)setWaterPerHour:(NSNumber *)perHour {
	[self setNormalPerHourLabel:waterPerHourLabel perHour:_intv(perHour)];
}


- (void)setBuildingImage:(UIImage *)buildingImage {
	self.buildingImageView.image = buildingImage;
}


- (void)setBuildingName:(NSString *)name buildingLevel:(NSInteger)level {
	self.buildingNameAndLevelLabel.text = [NSString stringWithFormat:@"%@ (%i)", name, level];
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


- (void)setNormalPerHourLabel:(UILabel *)perHourLabel perHour:(NSInteger)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%i/hr", perHour];
	if (perHour < 0) {
		perHourLabel.textColor = [UIColor redColor];
	} else {
		perHourLabel.textColor = [UIColor blackColor];
	}
}


- (void)setOppositePerHourLabel:(UILabel *)perHourLabel perHour:(NSInteger)perHour {
	perHourLabel.text = [NSString stringWithFormat:@"%i/hr", perHour];
	if (perHour <= 0) {
		perHourLabel.textColor = [UIColor blackColor];
	} else {
		perHourLabel.textColor = [UIColor redColor];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildingStats *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"BuildingStatsCell";
	
	LETableViewCellBuildingStats *cell = (LETableViewCellBuildingStats *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellBuildingStats alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.buildingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 34, 50, 50)] autorelease];
		cell.buildingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingImageView];
		
		cell.buildingNameAndLevelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 22)] autorelease];
		cell.buildingNameAndLevelLabel.backgroundColor = [UIColor clearColor];
		cell.buildingNameAndLevelLabel.textAlignment = UITextAlignmentLeft;
		cell.buildingNameAndLevelLabel.font = TEXT_FONT;
		cell.buildingNameAndLevelLabel.textColor = TEXT_COLOR;
		cell.buildingNameAndLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingNameAndLevelLabel];
		
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(68, 34, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/energy.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.energyPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(93, 35, 45, 20)] autorelease];
		cell.energyPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.energyPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.energyPerHourLabel.font = TEXT_SMALL_FONT;
		cell.energyPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(145, 34, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/food.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.foodPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(170, 35, 45, 20)] autorelease];
		cell.foodPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.foodPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.foodPerHourLabel.font = TEXT_SMALL_FONT;
		cell.foodPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(223, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/happiness.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.happinessPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(248, 35, 45, 20)] autorelease];
		cell.happinessPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.happinessPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.happinessPerHourLabel.font = TEXT_SMALL_FONT;
		cell.happinessPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.happinessPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.happinessPerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(68, 62, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/ore.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.orePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(93, 63, 45, 20)] autorelease];
		cell.orePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.orePerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.orePerHourLabel.font = TEXT_SMALL_FONT;
		cell.orePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.orePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.orePerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(145, 62, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/waste.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.wastePerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(170, 63, 45, 20)] autorelease];
		cell.wastePerHourLabel.backgroundColor = [UIColor clearColor];
		cell.wastePerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.wastePerHourLabel.font = TEXT_SMALL_FONT;
		cell.wastePerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.wastePerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wastePerHourLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(223, 62, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/water.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.waterPerHourLabel = [[[UILabel alloc] initWithFrame:CGRectMake(248, 62, 45, 20)] autorelease];
		cell.waterPerHourLabel.backgroundColor = [UIColor clearColor];
		cell.waterPerHourLabel.textAlignment = UITextAlignmentLeft;
		cell.waterPerHourLabel.font = TEXT_SMALL_FONT;
		cell.waterPerHourLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterPerHourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
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

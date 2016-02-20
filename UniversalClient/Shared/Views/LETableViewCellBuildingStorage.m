//
//  LETableViewCellBuildingStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildingStorage.h"
#import "LEMacros.h"
#import "Util.h"
#import "ResourceStorage.h"


@interface LETableViewCellBuildingStorage (PrivateMethods)
- (void)setStorageLabel:(UILabel *)storageLabel storage:(NSDecimalNumber *)storage;
@end


@implementation LETableViewCellBuildingStorage


@synthesize energyStorageLabel;
@synthesize foodStorageLabel;
@synthesize oreStorageLabel;
@synthesize wasteStorageLabel;
@synthesize waterStorageLabel;


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
	self.energyStorageLabel = nil;
	self.foodStorageLabel = nil;
	self.oreStorageLabel = nil;
	self.wasteStorageLabel = nil;
	self.waterStorageLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setResourceStorage:(ResourceStorage *)resourceStorage {
	[self setStorageLabel:energyStorageLabel storage:resourceStorage.energy];
	[self setStorageLabel:foodStorageLabel storage:resourceStorage.food];
	[self setStorageLabel:oreStorageLabel storage:resourceStorage.ore];
	[self setStorageLabel:wasteStorageLabel storage:resourceStorage.waste];
	[self setStorageLabel:waterStorageLabel storage:resourceStorage.water];
}


#pragma mark -
#pragma mark Private Methods


- (void)setStorageLabel:(UILabel *)storageLabel storage:(NSDecimalNumber *)storage {
	storageLabel.text = [Util prettyNSDecimalNumber:storage];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildingStorage *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"StorageCell";
	
	LETableViewCellBuildingStorage *cell = (LETableViewCellBuildingStorage *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBuildingStorage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UILabel *storageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 22)] autorelease];
		storageLabel.backgroundColor = [UIColor clearColor];
		storageLabel.textAlignment = NSTextAlignmentRight;
		storageLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		storageLabel.font = LABEL_FONT;
		storageLabel.textColor = LABEL_COLOR;
		storageLabel.text = @"Storage";
		[cell.contentView addSubview:storageLabel];

		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ENERGY_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.energyStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 23, 70, 20)] autorelease];
		cell.energyStorageLabel.backgroundColor = [UIColor clearColor];
		cell.energyStorageLabel.textAlignment = NSTextAlignmentLeft;
		cell.energyStorageLabel.font = TEXT_SMALL_FONT;
		cell.energyStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = FOOD_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.foodStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 23, 70, 20)] autorelease];
		cell.foodStorageLabel.backgroundColor = [UIColor clearColor];
		cell.foodStorageLabel.textAlignment = NSTextAlignmentLeft;
		cell.foodStorageLabel.font = TEXT_SMALL_FONT;
		cell.foodStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 22, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = ORE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.oreStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 23, 70, 20)] autorelease];
		cell.oreStorageLabel.backgroundColor = [UIColor clearColor];
		cell.oreStorageLabel.textAlignment = NSTextAlignmentLeft;
		cell.oreStorageLabel.font = TEXT_SMALL_FONT;
		cell.oreStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 50, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WASTE_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.wasteStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 51, 70, 20)] autorelease];
		cell.wasteStorageLabel.backgroundColor = [UIColor clearColor];
		cell.wasteStorageLabel.textAlignment = NSTextAlignmentLeft;
		cell.wasteStorageLabel.font = TEXT_SMALL_FONT;
		cell.wasteStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 50, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
		tmpImageView.image = WATER_ICON;
		[cell.contentView addSubview:tmpImageView];
		cell.waterStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 51, 70, 20)] autorelease];
		cell.waterStorageLabel.backgroundColor = [UIColor clearColor];
		cell.waterStorageLabel.textAlignment = NSTextAlignmentLeft;
		cell.waterStorageLabel.font = TEXT_SMALL_FONT;
		cell.waterStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterStorageLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 80.0;
}


@end

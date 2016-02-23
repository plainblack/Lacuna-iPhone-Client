//
//  LETableViewCellBuildableShipInfo.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildableShipInfo.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildableShip.h"


@implementation LETableViewCellBuildableShipInfo


@synthesize typeLabel;
@synthesize holdSizeLabel;
@synthesize berthLevelLabel;
@synthesize speedLabel;
@synthesize stealthLabel;
@synthesize combatLabel;
@synthesize maxOccupantLabel;
@synthesize shipImageView;


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
	self.typeLabel = nil;
	self.holdSizeLabel = nil;
    self.berthLevelLabel = nil;
	self.speedLabel = nil;
	self.stealthLabel = nil;
	self.combatLabel = nil;
	self.maxOccupantLabel = nil;
	self.shipImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setBuildableShip:(BuildableShip *)buildableShip {
	self.typeLabel.text = [Util prettyCodeValue:buildableShip.type];
	self.holdSizeLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"hold_size"]];
	self.speedLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"speed"]];
	self.stealthLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"stealth"]];
	self.combatLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"combat"]];
	self.maxOccupantLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"max_occupants"]];
    self.berthLevelLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"berth_level"]];
    if (isNull([buildableShip.attributes objectForKey:@"berth_level"])) {
        self.berthLevelLabel.text = @"";
    } else {
        self.berthLevelLabel.text = [NSString stringWithFormat:@"%@", [buildableShip.attributes objectForKey:@"berth_level"]];
    }
	NSString *shipImageName = [NSString stringWithFormat:@"assets/ships/%@.png", buildableShip.type];
	self.shipImageView.image = [UIImage imageNamed:shipImageName];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildableShipInfo *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"BuildableShipInfoCell";
	
	LETableViewCellBuildableShipInfo *cell = (LETableViewCellBuildableShipInfo *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBuildableShipInfo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
        CGFloat y = 10.0;
		cell.shipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y, 100, 100)] autorelease];
		cell.shipImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shipImageView];
		
		cell.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 190, 20)] autorelease];
		cell.typeLabel.backgroundColor = [UIColor clearColor];
		cell.typeLabel.textAlignment = NSTextAlignmentLeft;
		cell.typeLabel.font = TEXT_SMALL_FONT;
		cell.typeLabel.textColor = TEXT_SMALL_COLOR;
		cell.typeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.typeLabel];
		
        y += 20;
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Hold Size";
		[cell.contentView addSubview:tmpLabel];
		cell.holdSizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 130, 20)] autorelease];
		cell.holdSizeLabel.backgroundColor = [UIColor clearColor];
		cell.holdSizeLabel.textAlignment = NSTextAlignmentLeft;
		cell.holdSizeLabel.font = TEXT_SMALL_FONT;
		cell.holdSizeLabel.textColor = TEXT_SMALL_COLOR;
		cell.holdSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.holdSizeLabel];
        
        y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Berth Level";
		[cell.contentView addSubview:tmpLabel];
		cell.berthLevelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 100, 20)] autorelease];
		cell.berthLevelLabel.backgroundColor = [UIColor clearColor];
		cell.berthLevelLabel.textAlignment = NSTextAlignmentLeft;
		cell.berthLevelLabel.font = TEXT_SMALL_FONT;
		cell.berthLevelLabel.textColor = TEXT_SMALL_COLOR;
		cell.berthLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.berthLevelLabel];
        
        y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Speed";
		[cell.contentView addSubview:tmpLabel];
		cell.speedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 130, 20)] autorelease];
		cell.speedLabel.backgroundColor = [UIColor clearColor];
		cell.speedLabel.textAlignment = NSTextAlignmentLeft;
		cell.speedLabel.font = TEXT_SMALL_FONT;
		cell.speedLabel.textColor = TEXT_SMALL_COLOR;
		cell.speedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.speedLabel];
		
        y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Stealth";
		[cell.contentView addSubview:tmpLabel];
		cell.stealthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 130, 20)] autorelease];
		cell.stealthLabel.backgroundColor = [UIColor clearColor];
		cell.stealthLabel.textAlignment = NSTextAlignmentLeft;
		cell.stealthLabel.font = TEXT_SMALL_FONT;
		cell.stealthLabel.textColor = TEXT_SMALL_COLOR;
		cell.stealthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.stealthLabel];
		
        y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Combat";
		[cell.contentView addSubview:tmpLabel];
		cell.combatLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 100, 20)] autorelease];
		cell.combatLabel.backgroundColor = [UIColor clearColor];
		cell.combatLabel.textAlignment = NSTextAlignmentLeft;
		cell.combatLabel.font = TEXT_SMALL_FONT;
		cell.combatLabel.textColor = TEXT_SMALL_COLOR;
		cell.combatLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.combatLabel];
		
        y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 100, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Max Occupants";
		[cell.contentView addSubview:tmpLabel];
		cell.maxOccupantLabel = [[[UILabel alloc] initWithFrame:CGRectMake(225, y, 100, 20)] autorelease];
		cell.maxOccupantLabel.backgroundColor = [UIColor clearColor];
		cell.maxOccupantLabel.textAlignment = NSTextAlignmentLeft;
		cell.maxOccupantLabel.font = TEXT_SMALL_FONT;
		cell.maxOccupantLabel.textColor = TEXT_SMALL_COLOR;
		cell.maxOccupantLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.maxOccupantLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 140.0;
}


@end

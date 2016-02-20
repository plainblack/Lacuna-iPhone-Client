//
//  LETableViewCellUpgradableGlyphBuilding.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellUpgradableGlyphBuilding.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LETableViewCellUpgradableGlyphBuilding


@synthesize buildingBackgroundImageView;
@synthesize buildingImageView;
@synthesize buildingLevelLabel;
@synthesize buildingXLabel;
@synthesize buildingYLabel;


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
	self.buildingBackgroundImageView = nil;
	self.buildingImageView = nil;
	self.buildingLevelLabel = nil;
	self.buildingXLabel = nil;
	self.buildingYLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	Session *session = [Session sharedInstance];
	self.buildingBackgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]];
	self.buildingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [data objectForKey:@"image"]]];
	self.buildingLevelLabel.text = [data objectForKey:@"level"];
	self.buildingXLabel.text = [data objectForKey:@"x"];
	self.buildingYLabel.text = [data objectForKey:@"y"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellUpgradableGlyphBuilding *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"UpgradableGlyphBuildingCell";
	
	LETableViewCellUpgradableGlyphBuilding *cell = (LETableViewCellUpgradableGlyphBuilding *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellUpgradableGlyphBuilding alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.buildingBackgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.buildingBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingBackgroundImageView];
		cell.buildingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.buildingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingImageView];
		
		UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 50, 22)];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentLeft;
		tmpLabel.font = TEXT_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Level";
		[cell.contentView addSubview:tmpLabel];
		[tmpLabel release];
		cell.buildingLevelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175, 10, 65, 22)] autorelease];
		cell.buildingLevelLabel.backgroundColor = [UIColor clearColor];
		cell.buildingLevelLabel.textAlignment = NSTextAlignmentLeft;
		cell.buildingLevelLabel.font = TEXT_FONT;
		cell.buildingLevelLabel.textColor = TEXT_COLOR;
		cell.buildingLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingLevelLabel];
		
		tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 15, 15)];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentLeft;
		tmpLabel.font = TEXT_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"X";
		[cell.contentView addSubview:tmpLabel];
		[tmpLabel release];
		cell.buildingXLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160, 35, 30, 15)] autorelease];
		cell.buildingXLabel.backgroundColor = [UIColor clearColor];
		cell.buildingXLabel.textAlignment = NSTextAlignmentLeft;
		cell.buildingXLabel.font = TEXT_FONT;
		cell.buildingXLabel.textColor = TEXT_COLOR;
		cell.buildingXLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingXLabel];
		
		tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 55, 15, 15)];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentLeft;
		tmpLabel.font = TEXT_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Y";
		[cell.contentView addSubview:tmpLabel];
		[tmpLabel release];
		cell.buildingYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160, 55, 30, 15)] autorelease];
		cell.buildingYLabel.backgroundColor = [UIColor clearColor];
		cell.buildingYLabel.textAlignment = NSTextAlignmentLeft;
		cell.buildingYLabel.font = TEXT_FONT;
		cell.buildingYLabel.textColor = TEXT_COLOR;
		cell.buildingYLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.buildingYLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 120.0;
}


@end

//
//  LETableViewCellShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellShip.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"


@implementation LETableViewCellShip


@synthesize nameLabel;
@synthesize typeLabel;
@synthesize taskLabel;
@synthesize speedLabel;
@synthesize holdSizeLabel;
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
	self.nameLabel = nil;
	self.typeLabel = nil;
	self.taskLabel = nil;
	self.speedLabel = nil;
	self.holdSizeLabel = nil;
	self.shipImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShip:(Ship *)ship {
	self.nameLabel.text = ship.name;
	self.typeLabel.text = [Util prettyCodeValue:ship.type];
	self.taskLabel.text = ship.task;
	self.speedLabel.text = [Util prettyNSInteger:ship.speed];
	self.holdSizeLabel.text = [Util prettyNSInteger:ship.holdSize];
	NSString *shipImageName = [NSString stringWithFormat:@"assets/ships/%@.png", ship.type];
	self.shipImageView.image = [UIImage imageNamed:shipImageName];
}


#pragma mark --
#pragma mark Class Methods

+ (LETableViewCellShip *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ShipCell";
	
	LETableViewCellShip *cell = (LETableViewCellShip *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellShip alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.shipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.shipImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shipImageView];
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, 10, 200, 22)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = UITextAlignmentLeft;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameLabel];
		
		cell.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 30, 165, 20)] autorelease];
		cell.typeLabel.backgroundColor = [UIColor clearColor];
		cell.typeLabel.textAlignment = UITextAlignmentLeft;
		cell.typeLabel.font = TEXT_SMALL_FONT;
		cell.typeLabel.textColor = TEXT_SMALL_COLOR;
		cell.typeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.typeLabel];
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 45, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Task";
		[cell.contentView addSubview:tmpLabel];
		cell.taskLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, 45, 165, 20)] autorelease];
		cell.taskLabel.backgroundColor = [UIColor clearColor];
		cell.taskLabel.textAlignment = UITextAlignmentLeft;
		cell.taskLabel.font = TEXT_SMALL_FONT;
		cell.taskLabel.textColor = TEXT_SMALL_COLOR;
		cell.taskLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.taskLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 60, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Speed";
		[cell.contentView addSubview:tmpLabel];
		cell.speedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, 60, 100, 20)] autorelease];
		cell.speedLabel.backgroundColor = [UIColor clearColor];
		cell.speedLabel.textAlignment = UITextAlignmentLeft;
		cell.speedLabel.font = TEXT_SMALL_FONT;
		cell.speedLabel.textColor = TEXT_SMALL_COLOR;
		cell.speedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.speedLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 75, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Hold Size";
		[cell.contentView addSubview:tmpLabel];
		cell.holdSizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, 75, 100, 20)] autorelease];
		cell.holdSizeLabel.backgroundColor = [UIColor clearColor];
		cell.holdSizeLabel.textAlignment = UITextAlignmentLeft;
		cell.holdSizeLabel.font = TEXT_SMALL_FONT;
		cell.holdSizeLabel.textColor = TEXT_SMALL_COLOR;
		cell.holdSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.holdSizeLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 120.0;
}


@end

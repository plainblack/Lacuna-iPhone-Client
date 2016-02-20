//
//  LETableViewCellShipBuildQueueItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellShipBuildQueueItem.h"
#import "LEMacros.h"
#import "Util.h"
#import "ShipBuildQueueItem.h"


@implementation LETableViewCellShipBuildQueueItem


@synthesize typeLabel;
@synthesize dateCompleteLabel;
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
	self.dateCompleteLabel = nil;
	self.shipImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShipBuildQueueItem:(ShipBuildQueueItem *)shipBuildQueueItem {
	self.typeLabel.text = [Util prettyCodeValue:shipBuildQueueItem.type];
	self.dateCompleteLabel.text = [Util formatDate:shipBuildQueueItem.dateCompleted];
	NSString *shipImageName = [NSString stringWithFormat:@"assets/ships/%@.png", shipBuildQueueItem.type];
	self.shipImageView.image = [UIImage imageNamed:shipImageName];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellShipBuildQueueItem *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ShipBuildQueueItemCell";
	
	LETableViewCellShipBuildQueueItem *cell = (LETableViewCellShipBuildQueueItem *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellShipBuildQueueItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.shipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)] autorelease];
		cell.shipImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shipImageView];
		
		cell.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 225, 25)] autorelease];
		cell.typeLabel.backgroundColor = [UIColor clearColor];
		cell.typeLabel.textAlignment = NSTextAlignmentLeft;
		cell.typeLabel.font = TEXT_FONT;
		cell.typeLabel.textColor = TEXT_COLOR;
		cell.typeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.typeLabel];

		cell.dateCompleteLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 35, 225, 20)] autorelease];
		cell.dateCompleteLabel.backgroundColor = [UIColor clearColor];
		cell.dateCompleteLabel.textAlignment = NSTextAlignmentLeft;
		cell.dateCompleteLabel.font = TEXT_SMALL_FONT;
		cell.dateCompleteLabel.textColor = TEXT_SMALL_COLOR;
		cell.dateCompleteLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.dateCompleteLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 95.0;
}


@end

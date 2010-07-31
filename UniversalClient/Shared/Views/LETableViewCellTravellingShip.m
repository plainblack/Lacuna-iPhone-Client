//
//  LETableViewCellTravellingShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellTravellingShip.h"
#import "LEMacros.h"
#import "Util.h"
#import "TravellingShip.h"


@implementation LETableViewCellTravellingShip


@synthesize dateArrivesLabel;
@synthesize fromLabel;
@synthesize toLabel;
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
	self.dateArrivesLabel = nil;
	self.fromLabel = nil;
	self.toLabel = nil;
	self.shipImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setTravellingShip:(TravellingShip *)travellingShip {
	self.dateArrivesLabel.text = [Util formatDate:travellingShip.dateArrives];
	self.fromLabel.text = [NSString stringWithFormat:@"%@: %@", travellingShip.fromType, travellingShip.fromName];
	self.toLabel.text = [NSString stringWithFormat:@"%@: %@", travellingShip.toType, travellingShip.toName];
	NSString *shipImageName = [NSString stringWithFormat:@"assets/ships/%@.png", travellingShip.type];
	self.shipImageView.image = [UIImage imageNamed:shipImageName];
}


#pragma mark --
#pragma mark Class Methods

+ (LETableViewCellTravellingShip *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ShipCell";
	
	LETableViewCellTravellingShip *cell = (LETableViewCellTravellingShip *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellTravellingShip alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.shipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)] autorelease];
		cell.shipImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shipImageView];
		
		cell.dateArrivesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, 10, 200, 22)] autorelease];
		cell.dateArrivesLabel.backgroundColor = [UIColor clearColor];
		cell.dateArrivesLabel.textAlignment = UITextAlignmentLeft;
		cell.dateArrivesLabel.font = TEXT_FONT;
		cell.dateArrivesLabel.textColor = TEXT_COLOR;
		cell.dateArrivesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.dateArrivesLabel];
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 35, 40, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"From";
		[cell.contentView addSubview:tmpLabel];
		cell.fromLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165, 35, 120, 20)] autorelease];
		cell.fromLabel.backgroundColor = [UIColor clearColor];
		cell.fromLabel.textAlignment = UITextAlignmentLeft;
		cell.fromLabel.font = TEXT_SMALL_FONT;
		cell.fromLabel.textColor = TEXT_SMALL_COLOR;
		cell.fromLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.fromLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 55, 40, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"To";
		[cell.contentView addSubview:tmpLabel];
		cell.toLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165, 55, 120, 20)] autorelease];
		cell.toLabel.backgroundColor = [UIColor clearColor];
		cell.toLabel.textAlignment = UITextAlignmentLeft;
		cell.toLabel.font = TEXT_SMALL_FONT;
		cell.toLabel.textColor = TEXT_SMALL_COLOR;
		cell.toLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.toLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 120.0;
}


@end

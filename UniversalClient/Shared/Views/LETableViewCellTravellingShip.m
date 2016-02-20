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
#import "Ship.h"


@implementation LETableViewCellTravellingShip


@synthesize dateStartedLabel;
@synthesize dateArrivesLabel;
@synthesize fromNameLabel;
@synthesize toNameLabel;


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
	self.dateStartedLabel = nil;
	self.dateArrivesLabel = nil;
	self.fromNameLabel = nil;
	self.toNameLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShip:(Ship *)ship {
	self.dateStartedLabel.text = [Util formatDate:ship.dateStarted];
	self.dateArrivesLabel.text = [Util formatDate:ship.dateArrives];
	self.fromNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", ship.fromName, ship.fromType];
	self.toNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", ship.toName, ship.toType];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellTravellingShip *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"TravellingShipCell";
	
	LETableViewCellTravellingShip *cell = (LETableViewCellTravellingShip *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellTravellingShip alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		CGFloat y = 10.0;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y+5, 90, 15)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Arrives";
		[cell.contentView addSubview:tmpLabel];
		cell.dateArrivesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y, 200, 22)] autorelease];
		cell.dateArrivesLabel.backgroundColor = [UIColor clearColor];
		cell.dateArrivesLabel.textAlignment = NSTextAlignmentLeft;
		cell.dateArrivesLabel.font = TEXT_FONT;
		cell.dateArrivesLabel.textColor = TEXT_COLOR;
		cell.dateArrivesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.dateArrivesLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y+5, 90, 15)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Started";
		[cell.contentView addSubview:tmpLabel];
		cell.dateStartedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y, 200, 22)] autorelease];
		cell.dateStartedLabel.backgroundColor = [UIColor clearColor];
		cell.dateStartedLabel.textAlignment = NSTextAlignmentLeft;
		cell.dateStartedLabel.font = TEXT_FONT;
		cell.dateStartedLabel.textColor = TEXT_COLOR;
		cell.dateStartedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.dateStartedLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y+7, 90, 13)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"From";
		[cell.contentView addSubview:tmpLabel];
		cell.fromNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y+5, 200, 15)] autorelease];
		cell.fromNameLabel.backgroundColor = [UIColor clearColor];
		cell.fromNameLabel.textAlignment = NSTextAlignmentLeft;
		cell.fromNameLabel.font = TEXT_SMALL_FONT;
		cell.fromNameLabel.textColor = TEXT_SMALL_COLOR;
		cell.fromNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.fromNameLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y+7, 90, 13)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"To";
		[cell.contentView addSubview:tmpLabel];
		cell.toNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y+5, 200, 15)] autorelease];
		cell.toNameLabel.backgroundColor = [UIColor clearColor];
		cell.toNameLabel.textAlignment = NSTextAlignmentLeft;
		cell.toNameLabel.font = TEXT_SMALL_FONT;
		cell.toNameLabel.textColor = TEXT_SMALL_COLOR;
		cell.toNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.toNameLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 100.0;
}


@end

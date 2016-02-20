//
//  LETableViewCellForeignIncomingShip
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellForeignIncomingShip.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"


@implementation LETableViewCellForeignIncomingShip


@synthesize dateArrivesLabel;
@synthesize fromNameLabel;
@synthesize fromEmpireLabel;


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
	self.fromNameLabel = nil;
	self.fromEmpireLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShip:(Ship *)ship {
	self.dateArrivesLabel.text = [Util formatDate:ship.dateArrives];
	self.fromNameLabel.text = ship.fromName;
	if (isNotNull(ship.fromEmpireName)) {
		self.fromEmpireLabel.text = ship.fromEmpireName;
	} else {
		self.fromEmpireLabel.text = @"UNKNOWN";
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellForeignIncomingShip *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ForeignIncomingShipCell";
	CGFloat y;
	
	LETableViewCellForeignIncomingShip *cell = (LETableViewCellForeignIncomingShip *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellForeignIncomingShip alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		y = 10.0;
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 90, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Arrives";
		[cell.contentView addSubview:tmpLabel];
		cell.dateArrivesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y, 200, 20)] autorelease];
		cell.dateArrivesLabel.backgroundColor = [UIColor clearColor];
		cell.dateArrivesLabel.textAlignment = NSTextAlignmentLeft;
		cell.dateArrivesLabel.font = TEXT_FONT;
		cell.dateArrivesLabel.textColor = TEXT_COLOR;
		cell.dateArrivesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.dateArrivesLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 90, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Sent by";
		[cell.contentView addSubview:tmpLabel];
		cell.fromEmpireLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y, 200, 20)] autorelease];
		cell.fromEmpireLabel.backgroundColor = [UIColor clearColor];
		cell.fromEmpireLabel.textAlignment = NSTextAlignmentLeft;
		cell.fromEmpireLabel.font = TEXT_SMALL_FONT;
		cell.fromEmpireLabel.textColor = TEXT_SMALL_COLOR;
		cell.fromEmpireLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.fromEmpireLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 90, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"On";
		[cell.contentView addSubview:tmpLabel];
		cell.fromNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110, y, 200, 20)] autorelease];
		cell.fromNameLabel.backgroundColor = [UIColor clearColor];
		cell.fromNameLabel.textAlignment = NSTextAlignmentLeft;
		cell.fromNameLabel.font = TEXT_SMALL_FONT;
		cell.fromNameLabel.textColor = TEXT_SMALL_COLOR;
		cell.fromNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.fromNameLabel];

		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 80.0;
}


@end

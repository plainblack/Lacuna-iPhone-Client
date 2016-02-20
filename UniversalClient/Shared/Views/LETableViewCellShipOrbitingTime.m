//
//  LETableViewCellShipOrbitingTime.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LETableViewCellShipOrbitingTime.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"


@implementation LETableViewCellShipOrbitingTime


@synthesize dateStartedLabel;
@synthesize fromNameLabel;


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
	self.fromNameLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShip:(Ship *)ship {
	self.dateStartedLabel.text = [Util formatDate:ship.dateStarted];
	self.fromNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", ship.fromName, ship.fromType];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellShipOrbitingTime *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"OrbitingTimeCell";
	
	LETableViewCellShipOrbitingTime *cell = (LETableViewCellShipOrbitingTime *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellShipOrbitingTime alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		CGFloat y = 10.0;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y+5, 90, 15)] autorelease];
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
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 60.0;
}


@end

//
//  LETableViewCellServerSelect.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellServerSelect.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellServerSelect


@synthesize nameLabel;
@synthesize locationLabel;
@synthesize statusLabel;
@synthesize typeLabel;


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
	self.locationLabel = nil;
	self.statusLabel = nil;
	self.typeLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setServer:(NSDictionary *)serverData {
	self.nameLabel.text = [serverData objectForKey:@"name"];
	self.locationLabel.text = [serverData objectForKey:@"location"];
	self.statusLabel.text = [serverData objectForKey:@"status"];
	self.typeLabel.text = [serverData objectForKey:@"type"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellServerSelect *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"ServerSelectCell";
	
	LETableViewCellServerSelect *cell = (LETableViewCellServerSelect *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellServerSelect alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = NSTextAlignmentCenter;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.nameLabel];
		
		cell.locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 15)] autorelease];
		cell.locationLabel.backgroundColor = [UIColor clearColor];
		cell.locationLabel.textAlignment = NSTextAlignmentCenter;
		cell.locationLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.locationLabel.font = LABEL_FONT;
		cell.locationLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.locationLabel];
		
		cell.statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 310, 15)] autorelease];
		cell.statusLabel.backgroundColor = [UIColor clearColor];
		cell.statusLabel.textAlignment = NSTextAlignmentCenter;
		cell.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.statusLabel.font = LABEL_FONT;
		cell.statusLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.statusLabel];
		
		cell.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 55, 310, 15)] autorelease];
		cell.typeLabel.backgroundColor = [UIColor clearColor];
		cell.typeLabel.textAlignment = NSTextAlignmentCenter;
		cell.typeLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.typeLabel.font = LABEL_FONT;
		cell.typeLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.typeLabel];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 75.0;
}


@end

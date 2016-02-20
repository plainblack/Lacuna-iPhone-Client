//
//  LETableViewCellStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellStar.h"
#import "LEMacros.h"
#import "Util.h"
#import "Star.h"


@implementation LETableViewCellStar


@synthesize nameLabel;
@synthesize locationLabel;
@synthesize starImageView;


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
	self.starImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setStar:(Star *)star {
	self.nameLabel.text = star.name;
	self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", star.x, star.y];
	NSString *starImageName = [NSString stringWithFormat:@"assets/star_map/%@.png", star.color];
	self.starImageView.image = [UIImage imageNamed:starImageName];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellStar *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable {
    static NSString *CellIdentifier = @"StarCell";
	
	LETableViewCellStar *cell = (LETableViewCellStar *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellStar alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.starImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
		cell.starImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.starImageView];
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 240, 20)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = NSTextAlignmentLeft;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameLabel];
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 35, 70, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Location";
		[cell.contentView addSubview:tmpLabel];
		cell.locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(145, 35, 140, 20)] autorelease];
		cell.locationLabel.backgroundColor = [UIColor clearColor];
		cell.locationLabel.textAlignment = NSTextAlignmentLeft;
		cell.locationLabel.font = TEXT_SMALL_FONT;
		cell.locationLabel.textColor = TEXT_SMALL_COLOR;
		cell.locationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.locationLabel];
		
		//Set Cell Defaults
		if (isSelectable) {
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 70.0;
}


@end

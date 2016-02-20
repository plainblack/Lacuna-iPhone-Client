//
//  LETableViewCellMiningPlatform.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellMiningPlatform.h"
#import "LEMacros.h"
#import "Util.h"
#import "MiningPlatform.h"

@implementation LETableViewCellMiningPlatform


@synthesize asteroidNameLabel;
@synthesize asteroidLocationLabel;
@synthesize shippingLabel;
@synthesize asteroidImageView;


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
	self.asteroidNameLabel = nil;
	self.asteroidLocationLabel = nil;
	self.shippingLabel = nil;
	self.asteroidImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setMiningPlatform:(MiningPlatform *)miningPlatform {
	self.asteroidNameLabel.text = miningPlatform.asteroidName;
	self.asteroidLocationLabel.text = [NSString stringWithFormat:@"%@ x %@", miningPlatform.asteroidX, miningPlatform.asteroidY];
	self.shippingLabel.text = [NSString stringWithFormat:@"%@%%", miningPlatform.shippingCapacity];
	NSString *asteroidImageName = [NSString stringWithFormat:@"assets/star_system/%@.png", miningPlatform.asteroidImageName];	
	self.asteroidImageView.image = [UIImage imageNamed:asteroidImageName];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellMiningPlatform *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"MiningPlatformCellSelectable";
	
	LETableViewCellMiningPlatform *cell = (LETableViewCellMiningPlatform *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellMiningPlatform alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		CGFloat y = 10.0;
		
		cell.asteroidImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y, 50, 50)] autorelease];
		cell.asteroidImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.asteroidImageView];
		
		cell.asteroidNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, y, 200, 22)] autorelease];
		cell.asteroidNameLabel.backgroundColor = [UIColor clearColor];
		cell.asteroidNameLabel.textAlignment = NSTextAlignmentLeft;
		cell.asteroidNameLabel.font = TEXT_FONT;
		cell.asteroidNameLabel.textColor = TEXT_COLOR;
		cell.asteroidNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.asteroidNameLabel];
		y += 20;
		
		UILabel *tmp = [[[UILabel alloc] initWithFrame:CGRectMake(70, y, 50, 20)] autorelease];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.textAlignment = NSTextAlignmentRight;
		tmp.font = TEXT_SMALL_FONT;
		tmp.textColor = TEXT_SMALL_COLOR;
		tmp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmp.text = @"Location";
		[cell.contentView addSubview:tmp];
		cell.asteroidLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(125, y, 165, 20)] autorelease];
		cell.asteroidLocationLabel.backgroundColor = [UIColor clearColor];
		cell.asteroidLocationLabel.textAlignment = NSTextAlignmentLeft;
		cell.asteroidLocationLabel.font = TEXT_SMALL_FONT;
		cell.asteroidLocationLabel.textColor = TEXT_SMALL_COLOR;
		cell.asteroidLocationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.asteroidLocationLabel];
		y += 15;
		
		tmp = [[[UILabel alloc] initWithFrame:CGRectMake(70, y, 100, 20)] autorelease];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.textAlignment = NSTextAlignmentRight;
		tmp.font = TEXT_SMALL_FONT;
		tmp.textColor = TEXT_SMALL_COLOR;
		tmp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmp.text = @"Shipping Capacity";
		[cell.contentView addSubview:tmp];
		cell.shippingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175, y, 105, 20)] autorelease];
		cell.shippingLabel.backgroundColor = [UIColor clearColor];
		cell.shippingLabel.textAlignment = NSTextAlignmentLeft;
		cell.shippingLabel.font = TEXT_SMALL_FONT;
		cell.shippingLabel.textColor = TEXT_SMALL_COLOR;
		cell.shippingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shippingLabel];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 70.0;
}


@end

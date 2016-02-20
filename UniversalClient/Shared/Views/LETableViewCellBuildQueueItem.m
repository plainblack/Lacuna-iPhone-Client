//
//  LETableViewCellBuildQueueItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildQueueItem.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellBuildQueueItem


@synthesize buildingNameText;
@synthesize levelLabel;
@synthesize levelText;
@synthesize durationLabel;
@synthesize durationText;


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
	self.buildingNameText = nil;
	self.levelLabel = nil;
	self.levelText = nil;
	self.durationLabel = nil;
	self.durationText = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)data {
	self.buildingNameText.text = [data objectForKey:@"name"];
	self.levelText.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"to_level"]];
	self.durationText.text = [Util prettyDuration:_intv([data objectForKey:@"seconds_remaining"])];

	//buildQueueItemCell.label.text = [NSString stringWithFormat:@"Level %@", [buildQueueItem objectForKey:@"to_level"]];
	//buildQueueItemCell.content.text = [NSString stringWithFormat:@"%@: %@", [buildQueueItem objectForKey:@"name"], [Util prettyDuration:_intv([buildQueueItem objectForKey:@"seconds_remaining"])]];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildQueueItem *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"BuildQueueItemCell";
	
	LETableViewCellBuildQueueItem *cell = (LETableViewCellBuildQueueItem *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBuildQueueItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.buildingNameText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.buildingNameText.backgroundColor = [UIColor clearColor];
		cell.buildingNameText.textAlignment = NSTextAlignmentLeft;
		cell.buildingNameText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.buildingNameText.font = TEXT_FONT;
		cell.buildingNameText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.buildingNameText];
		
		cell.levelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 60, 15)] autorelease];
		cell.levelLabel.backgroundColor = [UIColor clearColor];
		cell.levelLabel.textAlignment = NSTextAlignmentRight;
		cell.levelLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.levelLabel.font = TEXT_SMALL_FONT;
		cell.levelLabel.textColor = TEXT_COLOR;
		cell.levelLabel.text = @"Level:";
		[cell.contentView addSubview:cell.levelLabel];
		cell.levelText = [[[UILabel alloc] initWithFrame:CGRectMake(70, 25, 20, 15)] autorelease];
		cell.levelText.backgroundColor = [UIColor clearColor];
		cell.levelText.textAlignment = NSTextAlignmentLeft;
		cell.levelText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.levelText.font = TEXT_SMALL_FONT;
		cell.levelText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.levelText];
		
		cell.durationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 25, 60, 15)] autorelease];
		cell.durationLabel.backgroundColor = [UIColor clearColor];
		cell.durationLabel.textAlignment = NSTextAlignmentRight;
		cell.durationLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.durationLabel.font = TEXT_SMALL_FONT;
		cell.durationLabel.textColor = TEXT_COLOR;
		cell.durationLabel.text = @"Duration:";
		[cell.contentView addSubview:cell.durationLabel];
		cell.durationText = [[[UILabel alloc] initWithFrame:CGRectMake(165, 25, 150, 15)] autorelease];
		cell.durationText.backgroundColor = [UIColor clearColor];
		cell.durationText.textAlignment = NSTextAlignmentLeft;
		cell.durationText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.durationText.font = TEXT_SMALL_FONT;
		cell.durationText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.durationText];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 45.0;
}


@end

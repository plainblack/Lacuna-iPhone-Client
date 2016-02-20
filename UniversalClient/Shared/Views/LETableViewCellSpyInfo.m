//
//  LETableViewCellSpyInfo.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellSpyInfo.h"
#import "LEMacros.h"
#import "Util.h"
#import "Spy.h"


@implementation LETableViewCellSpyInfo


@synthesize nameContent;
@synthesize locationContent;
@synthesize assignmentContent;
@synthesize levelContent;
@synthesize politicsExpContent;
@synthesize mayhemExpContent;
@synthesize theftExpContent;
@synthesize intelExpContent;
@synthesize offenseRatingContent;
@synthesize defenseRatingContent;
@synthesize numOffensiveMissionsContent;
@synthesize numDefensiveMissionsContent;


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
	self.nameContent = nil;
	self.locationContent = nil;
	self.assignmentContent = nil;
	self.levelContent = nil;
	self.politicsExpContent = nil;
	self.mayhemExpContent = nil;
	self.theftExpContent = nil;
	self.intelExpContent = nil;
	self.offenseRatingContent = nil;
	self.defenseRatingContent = nil;
	self.numOffensiveMissionsContent = nil;
	self.numDefensiveMissionsContent = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(Spy *)spy {
	self.nameContent.text = spy.name;
	self.locationContent.text = spy.bodyName;
	self.assignmentContent.text = spy.assignment;
	self.levelContent.text = [Util prettyNSDecimalNumber:spy.level];
	self.politicsExpContent.text = [Util prettyNSDecimalNumber:spy.politicsExp];
	self.mayhemExpContent.text = [Util prettyNSDecimalNumber:spy.mayhemExp];
	self.theftExpContent.text = [Util prettyNSDecimalNumber:spy.theftExp];
	self.intelExpContent.text = [Util prettyNSDecimalNumber:spy.intelExp];
	self.offenseRatingContent.text = [Util prettyNSDecimalNumber:spy.offenseRating];
	self.defenseRatingContent.text = [Util prettyNSDecimalNumber:spy.defenseRating];
	self.numOffensiveMissionsContent.text = [Util prettyNSDecimalNumber:spy.numOffensiveMissions];
	self.numDefensiveMissionsContent.text = [Util prettyNSDecimalNumber:spy.numDefensiveMissions];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellSpyInfo *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"SpyInfoCell";
	NSInteger y = 10;
	
	LETableViewCellSpyInfo *cell = (LETableViewCellSpyInfo *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellSpyInfo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Name";
		[cell.contentView addSubview:tmpLabel];
		cell.nameContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 220, 20)] autorelease];
		cell.nameContent.backgroundColor = [UIColor clearColor];
		cell.nameContent.textAlignment = NSTextAlignmentLeft;
		cell.nameContent.font = TEXT_FONT;
		cell.nameContent.textColor = TEXT_COLOR;
		cell.nameContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameContent];
		
		y += 20;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Location";
		[cell.contentView addSubview:tmpLabel];
		cell.locationContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 220, 20)] autorelease];
		cell.locationContent.backgroundColor = [UIColor clearColor];
		cell.locationContent.textAlignment = NSTextAlignmentLeft;
		cell.locationContent.font = TEXT_SMALL_FONT;
		cell.locationContent.textColor = TEXT_SMALL_COLOR;
		cell.locationContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.locationContent];
		
		y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Assignment";
		[cell.contentView addSubview:tmpLabel];
		cell.assignmentContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 220, 20)] autorelease];
		cell.assignmentContent.backgroundColor = [UIColor clearColor];
		cell.assignmentContent.textAlignment = NSTextAlignmentLeft;
		cell.assignmentContent.font = TEXT_SMALL_FONT;
		cell.assignmentContent.textColor = TEXT_SMALL_COLOR;
		cell.assignmentContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.assignmentContent];
		
		y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Level";
		[cell.contentView addSubview:tmpLabel];
		cell.levelContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 220, 20)] autorelease];
		cell.levelContent.backgroundColor = [UIColor clearColor];
		cell.levelContent.textAlignment = NSTextAlignmentLeft;
		cell.levelContent.font = TEXT_SMALL_FONT;
		cell.levelContent.textColor = TEXT_SMALL_COLOR;
		cell.levelContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.levelContent];
		
		y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Experience";
		[cell.contentView addSubview:tmpLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Politics";
		[cell.contentView addSubview:tmpLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Mayhem";
		[cell.contentView addSubview:tmpLabel];

		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Theft";
		[cell.contentView addSubview:tmpLabel];

		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(250, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Intel";
		[cell.contentView addSubview:tmpLabel];

		y += 10;
		cell.politicsExpContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		cell.politicsExpContent.backgroundColor = [UIColor clearColor];
		cell.politicsExpContent.textAlignment = NSTextAlignmentCenter;
		cell.politicsExpContent.font = TEXT_SMALL_FONT;
		cell.politicsExpContent.textColor = TEXT_SMALL_COLOR;
		cell.politicsExpContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.politicsExpContent];
		
		cell.mayhemExpContent = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		cell.mayhemExpContent.backgroundColor = [UIColor clearColor];
		cell.mayhemExpContent.textAlignment = NSTextAlignmentCenter;
		cell.mayhemExpContent.font = TEXT_SMALL_FONT;
		cell.mayhemExpContent.textColor = TEXT_SMALL_COLOR;
		cell.mayhemExpContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.mayhemExpContent];
		
		cell.theftExpContent = [[[UILabel alloc] initWithFrame:CGRectMake(200, y, 50, 20)] autorelease];
		cell.theftExpContent.backgroundColor = [UIColor clearColor];
		cell.theftExpContent.textAlignment = NSTextAlignmentCenter;
		cell.theftExpContent.font = TEXT_SMALL_FONT;
		cell.theftExpContent.textColor = TEXT_SMALL_COLOR;
		cell.theftExpContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.theftExpContent];
		
		cell.intelExpContent = [[[UILabel alloc] initWithFrame:CGRectMake(250, y, 50, 20)] autorelease];
		cell.intelExpContent.backgroundColor = [UIColor clearColor];
		cell.intelExpContent.textAlignment = NSTextAlignmentCenter;
		cell.intelExpContent.font = TEXT_SMALL_FONT;
		cell.intelExpContent.textColor = TEXT_SMALL_COLOR;
		cell.intelExpContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.intelExpContent];
		
		y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Ratings";
		[cell.contentView addSubview:tmpLabel];

		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Offense";
		[cell.contentView addSubview:tmpLabel];

		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Defense";
		[cell.contentView addSubview:tmpLabel];

		y += 10;
		cell.offenseRatingContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		cell.offenseRatingContent.backgroundColor = [UIColor clearColor];
		cell.offenseRatingContent.textAlignment = NSTextAlignmentCenter;
		cell.offenseRatingContent.font = TEXT_SMALL_FONT;
		cell.offenseRatingContent.textColor = TEXT_SMALL_COLOR;
		cell.offenseRatingContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.offenseRatingContent];
		
		cell.defenseRatingContent = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		cell.defenseRatingContent.backgroundColor = [UIColor clearColor];
		cell.defenseRatingContent.textAlignment = NSTextAlignmentRight;
		cell.defenseRatingContent.font = TEXT_SMALL_FONT;
		cell.defenseRatingContent.textColor = TEXT_SMALL_COLOR;
		cell.defenseRatingContent.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.defenseRatingContent];
		
		y += 15;
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 150, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Offensive Mission Count";
		[cell.contentView addSubview:tmpLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160, y, 150, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Defensive Mission Count";
		[cell.contentView addSubview:tmpLabel];
		
		y += 15;
		cell.numOffensiveMissionsContent = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, 150, 20)] autorelease];
		cell.numOffensiveMissionsContent.backgroundColor = [UIColor clearColor];
		cell.numOffensiveMissionsContent.textAlignment = NSTextAlignmentCenter;
		cell.numOffensiveMissionsContent.font = TEXT_SMALL_FONT;
		cell.numOffensiveMissionsContent.textColor = TEXT_SMALL_COLOR;
		cell.numOffensiveMissionsContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.numOffensiveMissionsContent];

		cell.numDefensiveMissionsContent = [[[UILabel alloc] initWithFrame:CGRectMake(160, y, 150, 20)] autorelease];
		cell.numDefensiveMissionsContent.backgroundColor = [UIColor clearColor];
		cell.numDefensiveMissionsContent.textAlignment = NSTextAlignmentCenter;
		cell.numDefensiveMissionsContent.font = TEXT_SMALL_FONT;
		cell.numDefensiveMissionsContent.textColor = TEXT_SMALL_COLOR;
		cell.numDefensiveMissionsContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.numDefensiveMissionsContent];
		
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 165.0;
}


@end

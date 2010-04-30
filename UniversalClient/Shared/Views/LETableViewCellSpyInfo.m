//
//  LETableViewCellSpyInfo.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellSpyInfo.h"
#import "LEMacros.h"


@implementation LETableViewCellSpyInfo


@synthesize nameContent;
@synthesize locationContent;
@synthesize assignmentContent;


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
	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)spyData {
	self.nameContent.text = [spyData objectForKey:@"name"];
	self.locationContent.text = [[spyData objectForKey:@"assigned_to"] objectForKey:@"name"];
	self.assignmentContent.text = [spyData objectForKey:@"assignment"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellSpyInfo *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"SpyInfoCell";
	
	LETableViewCellSpyInfo *cell = (LETableViewCellSpyInfo *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellSpyInfo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Name";
		[cell.contentView addSubview:tmpLabel];
		cell.nameContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 220, 20)] autorelease];
		cell.nameContent.backgroundColor = [UIColor clearColor];
		cell.nameContent.textAlignment = UITextAlignmentLeft;
		cell.nameContent.font = TEXT_FONT;
		cell.nameContent.textColor = TEXT_COLOR;
		cell.nameContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameContent];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Location";
		[cell.contentView addSubview:tmpLabel];
		cell.locationContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 220, 20)] autorelease];
		cell.locationContent.backgroundColor = [UIColor clearColor];
		cell.locationContent.textAlignment = UITextAlignmentLeft;
		cell.locationContent.font = TEXT_SMALL_FONT;
		cell.locationContent.textColor = TEXT_SMALL_COLOR;
		cell.locationContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.locationContent];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 85, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Assignment";
		[cell.contentView addSubview:tmpLabel];
		cell.assignmentContent = [[[UILabel alloc] initWithFrame:CGRectMake(100, 50, 220, 20)] autorelease];
		cell.assignmentContent.backgroundColor = [UIColor clearColor];
		cell.assignmentContent.textAlignment = UITextAlignmentLeft;
		cell.assignmentContent.font = TEXT_SMALL_FONT;
		cell.assignmentContent.textColor = TEXT_SMALL_COLOR;
		cell.assignmentContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.assignmentContent];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 80.0;
}



@end

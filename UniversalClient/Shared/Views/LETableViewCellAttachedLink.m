//
//  LETableViewCellAttachedLink.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellAttachedLink.h"
#import "LEMacros.h"


@implementation LETableViewCellAttachedLink


@synthesize nameLabel;
@synthesize link;


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
	self.link = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)linkAttachmentData {
	self.nameLabel.text = [linkAttachmentData objectForKey:@"label"];
	self.link = [linkAttachmentData objectForKey:@"url"];

	//Set Cell Defaults
	if (self.link) {
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.nameLabel.font = BUTTON_TEXT_FONT;
		self.nameLabel.textColor = BUTTON_TEXT_COLOR;
	} else {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.nameLabel.font = TEXT_FONT;
		self.nameLabel.textColor = TEXT_COLOR;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellAttachedLink *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"AttachedLinkCell";
	
	LETableViewCellAttachedLink *cell = (LETableViewCellAttachedLink *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellAttachedLink alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = NSTextAlignmentCenter;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.nameLabel.text = @"TEST";
		[cell.contentView addSubview:cell.nameLabel];
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 40.0;
}


@end

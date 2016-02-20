//
//  LETableViewCellLabeledIconText.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellLabeledIconText.h"
#import "LEMacros.h"


@implementation LETableViewCellLabeledIconText


@synthesize label;
@synthesize icon;
@synthesize content;


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
	self.label = nil;
	self.icon = nil;
	self.content = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellLabeledIconText *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable{
	static NSString *SelectableCellIdentifier = @"LabeledIconTextCellSelectable";
	static NSString *NormalCellIdentifier = @"LabeledIconTextCell";
	NSString *cellIdentifier;
	if (isSelectable) {
		cellIdentifier = SelectableCellIdentifier;
	} else {
		cellIdentifier = NormalCellIdentifier;
	}
	
	LETableViewCellLabeledIconText *cell = (LETableViewCellLabeledIconText *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellLabeledIconText alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = NSTextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		[cell.contentView addSubview:cell.label];
		
		cell.icon = [[[UIImageView alloc] initWithFrame:CGRectMake(105, 11, 22, 22)] autorelease];
		cell.icon.backgroundColor = [UIColor clearColor];
		cell.icon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.icon.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:cell.icon];
		
		cell.content = [[[UILabel alloc] initWithFrame:CGRectMake(130, 6, 185, 31)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = NSTextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.content.font = TEXT_FONT;
		cell.content.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.content];
		
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
	return tableView.rowHeight;
}


@end

//
//  LETableViewCellLongLabeledText.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellLongLabeledText.h"
#import "LEMacros.h"


@implementation LETableViewCellLongLabeledText


@synthesize label;
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
	self.content = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellLongLabeledText *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable{
	static NSString *SelectableCellIdentifier = @"LongLabeledTextCellSelectable";
	static NSString *NormalCellIdentifier = @"LongLabeledTextCell";
	NSString *cellIdentifier;
	if (isSelectable) {
		cellIdentifier = SelectableCellIdentifier;
	} else {
		cellIdentifier = NormalCellIdentifier;
	}
	
	LETableViewCellLongLabeledText *cell = (LETableViewCellLongLabeledText *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellLongLabeledText alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 195, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = NSTextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		[cell.contentView addSubview:cell.label];
		
		cell.content = [[[UILabel alloc] initWithFrame:CGRectMake(205, 6, 110, 31)] autorelease];
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

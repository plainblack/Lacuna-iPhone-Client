//
//  LETableViewCellLabeledParagraph.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellLabeledParagraph.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellLabeledParagraph


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

+ (LETableViewCellLabeledParagraph *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"LabeledParagraphCell";
	
	LETableViewCellLabeledParagraph *cell = (LETableViewCellLabeledParagraph *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellLabeledParagraph alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = NSTextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.label];
		cell.content = [[[UITextView alloc] initWithFrame:CGRectMake(100, 3, 215, 35)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = NSTextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.content.editable = NO;
		cell.content.scrollEnabled = NO;
		cell.content.userInteractionEnabled = NO;
		[cell.contentView addSubview:cell.content];
		
		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.content.font = TEXT_FONT;
		cell.content.textColor = TEXT_COLOR;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView text:(NSString *)text {
	CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width - 135, 0);
	CGFloat suggestedHeight = [Util heightForText:text inFrame:frame withFont:TEXT_FONT] + 12;
	if (suggestedHeight < tableView.rowHeight) {
		return tableView.rowHeight;
	} else {
		return suggestedHeight;
	}
}


@end

//
//  LETableViewCellParagraph.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellParagraph.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellParagraph


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
	self.content = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellParagraph *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"ParagraphCell";
	
	LETableViewCellParagraph *cell = (LETableViewCellParagraph *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellParagraph alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.content = [[[UITextView alloc] initWithFrame:CGRectMake(5, 0, 310, 44)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = NSTextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.content.editable = NO;
		cell.content.scrollEnabled = NO;
		[cell.contentView addSubview:cell.content];
		cell.content.font = PARAGRAPH_FONT;
		cell.content.textColor = PARAGRAPH_COLOR;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView text:(NSString *)text {
	CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width-20, tableView.bounds.size.height);
	CGFloat suggestedHeight = [Util heightForText:text inFrame:frame withFont:PARAGRAPH_FONT] + 22;
	if (suggestedHeight < tableView.rowHeight) {
		return tableView.rowHeight;
	} else {
		return suggestedHeight;
	}
}


@end

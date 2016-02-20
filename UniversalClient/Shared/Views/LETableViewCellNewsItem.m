//
//  LETableViewCellNewsItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellNewsItem.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellNewsItem


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
#pragma mark Instance Methods

- (void)displayNewsItem:(NSDictionary *)newsItem {
	self.label.text = [Util prettyDate:[newsItem objectForKey:@"date"]];
	self.content.text = [newsItem objectForKey:@"headline"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellNewsItem *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"NewsItemCell";
	
	LETableViewCellNewsItem *cell = (LETableViewCellNewsItem *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellNewsItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 20)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = NSTextAlignmentLeft;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.label];
		cell.content = [[[UITextView alloc] initWithFrame:CGRectMake(5, 20, 310, 24)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = NSTextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.content.editable = NO;
		cell.content.scrollEnabled = NO;
		cell.content.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
		[cell.contentView addSubview:cell.content];
		
		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.content.font = TEXT_SMALL_FONT;
		cell.content.textColor = TEXT_SMALL_COLOR;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView text:(NSString *)text {
	CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width - 10, 0);
	CGFloat suggestedHeight = [Util heightForText:text inFrame:frame withFont:TEXT_SMALL_FONT] + 25;
	if (suggestedHeight < tableView.rowHeight) {
		return tableView.rowHeight;
	} else {
		return suggestedHeight;
	}
}


@end

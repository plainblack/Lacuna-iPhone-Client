//
//  LETableViewCellDictionary.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellDictionary.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellDictionary


@synthesize headingLabel;
@synthesize keys;
@synthesize values;


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
	self.headingLabel = nil;
	self.keys = nil;
	self.values = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setHeading:(NSString *)heading Data:(NSDictionary *)data {
	[self.keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj removeFromSuperview];
	}];
	[self.keys removeAllObjects];
	[self.values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj removeFromSuperview];
	}];
	[self.values removeAllObjects];
	
	self.headingLabel.text = heading;
	
	NSArray *tmp = [[data allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSInteger y = 10;
	UILabel *tmpKeyLabel;
	UILabel *tmpValueLabel;
	for (id key in tmp) {
		id value = [data objectForKey:key];
		tmpKeyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(105, y, 70, 15)] autorelease];
		[self.keys addObject:tmpKeyLabel];
		tmpKeyLabel.backgroundColor = [UIColor clearColor];
		tmpKeyLabel.textAlignment = UITextAlignmentRight;
		tmpKeyLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		tmpKeyLabel.font = TEXT_SMALL_FONT;
		tmpKeyLabel.textColor = TEXT_COLOR;
		tmpKeyLabel.text = [NSString stringWithFormat:@"%@", key];
		[self.contentView addSubview:tmpKeyLabel];
		
		tmpValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(180, y, 130, 15)] autorelease];
		[self.keys addObject:tmpValueLabel];
		tmpValueLabel.backgroundColor = [UIColor clearColor];
		tmpValueLabel.textAlignment = UITextAlignmentLeft;
		tmpValueLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		tmpValueLabel.font = TEXT_SMALL_FONT;
		tmpValueLabel.textColor = TEXT_COLOR;
		tmpValueLabel.text = [NSString stringWithFormat:@"%@", value];
		[self.contentView addSubview:tmpValueLabel];
		
		y = y + 15;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellDictionary *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"DictionaryCell";
	
	LETableViewCellDictionary *cell = (LETableViewCellDictionary *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellDictionary alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		cell.headingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.headingLabel.backgroundColor = [UIColor clearColor];
		cell.headingLabel.textAlignment = UITextAlignmentRight;
		cell.headingLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		cell.headingLabel.font = LABEL_FONT;
		cell.headingLabel.textColor = LABEL_COLOR;
		[cell.contentView addSubview:cell.headingLabel];
		
		cell.keys = [NSMutableArray arrayWithCapacity:0];
		cell.values = [NSMutableArray arrayWithCapacity:0];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView numItems:(NSInteger)numItems {
	if (numItems > 1) {
		return 20.0 + (15.0 * numItems);
	} else {
		return 35.0;
	}
}


@end

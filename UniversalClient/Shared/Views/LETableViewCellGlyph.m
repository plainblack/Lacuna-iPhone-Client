//
//  LETableViewCellGlyph.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellGlyph.h"
#import "LEMacros.h"
#import "Glyph.h"


@implementation LETableViewCellGlyph


@synthesize imageView;
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
	self.imageView = nil;
	self.content = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setGlyph:(Glyph *)glyph {
	self.imageView.image = [UIImage imageNamed:glyph.imageName];
	self.content.text = glyph.type;
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellGlyph *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"GlyphCell";
	
	LETableViewCellGlyph *cell = (LETableViewCellGlyph *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellGlyph alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.imageView = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.imageView.backgroundColor = [UIColor clearColor];
		cell.imageView.contentMode = UIViewContentModeRight;
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
		[cell.contentView addSubview:cell.imageView];
		
		cell.content = [[[UILabel alloc] initWithFrame:CGRectMake(105, 6, 210, 31)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = UITextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.content.font = TEXT_FONT;
		cell.content.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.content];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

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
	self.content.text = [glyph.type capitalizedString];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellGlyph *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable {
	static NSString *SelectableCellIdentifier = @"GlyphCellSelectable";
	static NSString *CellIdentifier = @"GlyphCell";
	
	NSString *cellIdentifier;
	if (isSelectable) {
		cellIdentifier = SelectableCellIdentifier;
	} else {
		cellIdentifier = CellIdentifier;
	}
	
	LETableViewCellGlyph *cell = (LETableViewCellGlyph *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellGlyph alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 95, 44)] autorelease];
		cell.imageView.backgroundColor = [UIColor clearColor];
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		[cell.contentView addSubview:cell.imageView];
		
		cell.content = [[[UILabel alloc] initWithFrame:CGRectMake(105, 6, 210, 31)] autorelease];
		cell.content.backgroundColor = [UIColor clearColor];
		cell.content.textAlignment = NSTextAlignmentLeft;
		cell.content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.content.font = BUTTON_TEXT_FONT;
		[cell.contentView addSubview:cell.content];
		
		if (isSelectable) {
			cell.content.textColor = BUTTON_TEXT_COLOR;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		} else {
			cell.content.textColor = TEXT_COLOR;
		}

	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 54.0f;
}


@end

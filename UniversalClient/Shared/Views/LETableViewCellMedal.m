//
//  LETableViewCellMedal.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellMedal.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellMedal


@synthesize medalNameLabel;
@synthesize dateLabel;
@synthesize noteView;
@synthesize imageView;


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
	self.medalNameLabel = nil;
	self.dateLabel = nil;
	self.noteView = nil;
	self.imageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)data {
	self.medalNameLabel.text = [data objectForKey:@"name"];
	self.dateLabel.text = [Util prettyDate:[data objectForKey:@"date"]];
	NSString *note = [data objectForKey:@"note"];
	if (isNotNull(note)) {
		self.noteView.text = note;
	} else {
		self.noteView.text = @"";
	}
	self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/medal/%@.png", [data objectForKey:@"image"]]];
}

#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellMedal *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"MedalTextCell";
	
	LETableViewCellMedal *cell = (LETableViewCellMedal *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellMedal alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)] autorelease];
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.imageView];

		cell.medalNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 10, 222, 20)] autorelease];
		cell.medalNameLabel.backgroundColor = [UIColor clearColor];
		cell.medalNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.medalNameLabel.font = TEXT_FONT;
		cell.medalNameLabel.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.medalNameLabel];

		cell.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 30, 222, 20)] autorelease];
		cell.dateLabel.backgroundColor = [UIColor clearColor];
		cell.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.dateLabel.font = LABEL_FONT;
		cell.dateLabel.textColor = LABEL_COLOR;
		[cell.contentView addSubview:cell.dateLabel];

		cell.noteView = [[[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 65)] autorelease];
		cell.noteView.backgroundColor = [UIColor clearColor];
		cell.noteView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.noteView.editable = NO;
		cell.noteView.scrollEnabled = NO;
		cell.noteView.font = PARAGRAPH_FONT;
		cell.noteView.textColor = PARAGRAPH_COLOR;
		[cell.contentView addSubview:cell.noteView];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView withMedal:(NSDictionary *)medal {
	NSObject *note = [medal objectForKey:@"note"];
	if (note && note != [NSNull null]) {
		return 135.0;
	} else {
		return 70.0;
	}
}


@end

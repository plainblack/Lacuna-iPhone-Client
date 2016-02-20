//
//  LETableViewCellBody.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBody.h"
#import "LEMacros.h"


@implementation LETableViewCellBody


@synthesize planetImageView;
@synthesize planetLabel;
@synthesize systemLabel;
@synthesize orbitLabel;
@synthesize empireLabel;


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
	self.planetImageView = nil;
	self.planetLabel = nil;
	self.systemLabel = nil;
	self.orbitLabel = nil;
	self.empireLabel = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBody *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable {
    static NSString *CellIdentifier = @"BodyCell";
	
	LETableViewCellBody *cell = (LETableViewCellBody *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBody alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.planetImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)] autorelease];
		cell.planetImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.planetImageView];

		cell.planetLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 10, 222, 22)] autorelease];
		cell.planetLabel.backgroundColor = [UIColor clearColor];
		cell.planetLabel.textAlignment = NSTextAlignmentLeft;
		cell.planetLabel.font = TEXT_FONT;
		cell.planetLabel.textColor = TEXT_COLOR;
		cell.planetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.planetLabel];

		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 26, 51, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"System";
		[cell.contentView addSubview:tmpLabel];
		cell.systemLabel = [[[UILabel alloc] initWithFrame:CGRectMake(137, 26, 163, 20)] autorelease];
		cell.systemLabel.backgroundColor = [UIColor clearColor];
		cell.systemLabel.textAlignment = NSTextAlignmentLeft;
		cell.systemLabel.font = TEXT_SMALL_FONT;
		cell.systemLabel.textColor = TEXT_SMALL_COLOR;
		cell.systemLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.systemLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 39, 51, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Orbit";
		[cell.contentView addSubview:tmpLabel];
		cell.orbitLabel = [[[UILabel alloc] initWithFrame:CGRectMake(137, 39, 163, 20)] autorelease];
		cell.orbitLabel.backgroundColor = [UIColor clearColor];
		cell.orbitLabel.textAlignment = NSTextAlignmentLeft;
		cell.orbitLabel.font = TEXT_SMALL_FONT;
		cell.orbitLabel.textColor = TEXT_SMALL_COLOR;
		cell.orbitLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.orbitLabel];

		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 52, 51, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Empire";
		[cell.contentView addSubview:tmpLabel];
		cell.empireLabel = [[[UILabel alloc] initWithFrame:CGRectMake(137, 52, 163, 20)] autorelease];
		cell.empireLabel.backgroundColor = [UIColor clearColor];
		cell.empireLabel.textAlignment = NSTextAlignmentLeft;
		cell.empireLabel.font = TEXT_SMALL_FONT;
		cell.empireLabel.textColor = TEXT_SMALL_COLOR;
		cell.empireLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.empireLabel];
		
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
	return 80.0;
}



@end

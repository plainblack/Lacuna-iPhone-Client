//
//  LETableViewCellUnbuildable.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellUnbuildable.h"
#import "LEMacros.h"


@implementation LETableViewCellUnbuildable


@synthesize reasonLabel;


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
	self.reasonLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setReason:(NSString *)reason {
	self.reasonLabel.text = reason;
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellUnbuildable *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"UnbuildableCell";
	
	LETableViewCellUnbuildable *cell = (LETableViewCellUnbuildable *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellUnbuildable alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 22)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = TEXT_FONT;
		tmpLabel.textColor = TEXT_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Not Buildable";
		[cell.contentView addSubview:tmpLabel];

		cell.reasonLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 52)] autorelease];
		cell.reasonLabel.backgroundColor = [UIColor clearColor];
		cell.reasonLabel.textAlignment = NSTextAlignmentCenter;
		cell.reasonLabel.font = TEXT_SMALL_FONT;
		cell.reasonLabel.textColor = TEXT_SMALL_COLOR;
		cell.reasonLabel.numberOfLines = 0;
		cell.reasonLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.reasonLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 88.0;
}


@end

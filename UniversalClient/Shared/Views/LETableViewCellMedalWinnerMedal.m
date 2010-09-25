//
//  LETableViewCellMedalImageName.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellMedalWinnerMedal.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellMedalWinnerMedal


@synthesize medalNameLabel;
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
	self.imageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)data {
	self.medalNameLabel.text = [data objectForKey:@"medal_name"];
	self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/medal/%@.png", [data objectForKey:@"medal_image"]]];
}

#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellMedalWinnerMedal *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"MedalWinnerMedalCell";
	
	LETableViewCellMedalWinnerMedal *cell = (LETableViewCellMedalWinnerMedal *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellMedalWinnerMedal alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)] autorelease];
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:cell.imageView];
		
		cell.medalNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 5, 255, 50)] autorelease];
		cell.medalNameLabel.backgroundColor = [UIColor clearColor];
		cell.medalNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.medalNameLabel.font = TEXT_FONT;
		cell.medalNameLabel.textColor = TEXT_COLOR;
		cell.medalNameLabel.numberOfLines = 2;
		[cell.contentView addSubview:cell.medalNameLabel];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 60.0;
}


@end

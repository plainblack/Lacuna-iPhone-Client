//
//  LETableViewCellPlanType.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LETableViewCellPlanType.h"
#import "LEMacros.h"


@implementation LETableViewCellPlanType

@synthesize name;
@synthesize backImageView;
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
	self.name = nil;
    self.backImageView = nil;
	self.imageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setPlanType:(NSMutableDictionary *)planType {
	self.name.text = [planType objectForKey:@"name"];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [planType objectForKey:@"image"]]];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellPlanType *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"PlanTypeCell";
	
	LETableViewCellPlanType *cell = (LETableViewCellPlanType *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellPlanType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.backImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
		cell.backImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cell.backImageView.image = [UIImage imageNamed:@"/assets/planet_side/surface-station.png"];
		[cell.contentView addSubview:cell.backImageView];
		cell.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.imageView];

		cell.name = [[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 230, 50)] autorelease];
		cell.name.backgroundColor = [UIColor clearColor];
		cell.name.textAlignment = NSTextAlignmentLeft;
		cell.name.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        cell.name.numberOfLines = 0;
		cell.name.font = BUTTON_TEXT_FONT;
		cell.name.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.name];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 70.0f;
}


@end

//
//  LETableViewCellSavedEmpire.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellSavedEmpire.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellSavedEmpire


@synthesize empireNameText;
@synthesize serverUriLabel;


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
	self.empireNameText = nil;
	self.serverUriLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)data {
	self.empireNameText.text = [data objectForKey:@"username"];
	//KEVIN REMOVE AFTER BETA
	if ([data objectForKey:@"uri"]) {
		self.serverUriLabel.text = [data objectForKey:@"uri"];
	} else {
		self.serverUriLabel.text = @"https://pt.lacunaexpanse.com/";
	}

}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellSavedEmpire *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"SavedEmpireCell";
	
	LETableViewCellSavedEmpire *cell = (LETableViewCellSavedEmpire *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellSavedEmpire alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		cell.empireNameText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.empireNameText.backgroundColor = [UIColor clearColor];
		cell.empireNameText.textAlignment = NSTextAlignmentCenter;
		cell.empireNameText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.empireNameText.font = BUTTON_TEXT_FONT;
		cell.empireNameText.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.empireNameText];
		
		cell.serverUriLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 15)] autorelease];
		cell.serverUriLabel.backgroundColor = [UIColor clearColor];
		cell.serverUriLabel.textAlignment = NSTextAlignmentCenter;
		cell.serverUriLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.serverUriLabel.font = TEXT_SMALL_FONT;
		cell.serverUriLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.serverUriLabel];
		
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 45.0;
}


@end

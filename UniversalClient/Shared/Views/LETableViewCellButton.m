//
//  LETableViewCellButton.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/7/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellButton.h"
#import "LEMacros.h"


@implementation LETableViewCellButton

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
    [super dealloc];
}


+ (LETableViewCellButton *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"ButtonCell";
	
	LETableViewCellButton *cell = (LETableViewCellButton *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//Load from NIB
		cell = [[[LETableViewCellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		
		//Set Font stuff
		cell.textLabel.font = BUTTON_TEXT_FONT;
		cell.textLabel.textColor = BUTTON_TEXT_COLOR;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

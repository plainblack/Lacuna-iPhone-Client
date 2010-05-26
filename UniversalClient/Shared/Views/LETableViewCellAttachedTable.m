//
//  LETableViewCellAttachedTable.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellAttachedTable.h"
#import "LEMacros.h"


@implementation LETableViewCellAttachedTable


@synthesize nameLabel;
@synthesize link;


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
	self.nameLabel = nil;
	self.link = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)imageAttachmentData {
	 self.nameLabel = [imageAttachmentData objectForKey:@"title"];
	 self.link = [imageAttachmentData objectForKey:@"link"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellAttachedTable *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"AttachedImageCell";
	
	LETableViewCellAttachedTable *cell = (LETableViewCellAttachedTable *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellAttachedTable alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 300, 20)];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = UITextAlignmentRight;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 80.0;
}


@end

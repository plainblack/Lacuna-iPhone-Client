//
//  LETableViewCellAttachedImage.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellAttachedImage.h"
#import "LEMacros.h"


@implementation LETableViewCellAttachedImage


@synthesize imageView;
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
	self.imageView = nil;
	self.nameLabel = nil;
	self.link = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setData:(NSDictionary *)imageAttachmentData {
	NSURL *url = [NSURL URLWithString:[imageAttachmentData objectForKey:@"url"]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	self.imageView.image = [UIImage imageWithData:data];
	self.nameLabel.text = [imageAttachmentData objectForKey:@"title"];
	self.link = [imageAttachmentData objectForKey:@"link"];

	//Set Cell Defaults
	if (self.link) {
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.nameLabel.font = BUTTON_TEXT_FONT;
		self.nameLabel.textColor = BUTTON_TEXT_COLOR;
	} else {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.nameLabel.font = TEXT_FONT;
		self.nameLabel.textColor = TEXT_COLOR;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellAttachedImage *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"AttachedImageCell";
	
	LETableViewCellAttachedImage *cell = (LETableViewCellAttachedImage *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellAttachedImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UIImage *image = TIME_ICON;
		cell.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
		cell.imageView.frame = CGRectMake(135, 10, 50, 50);
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:cell.imageView];
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 65, 300, 20)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = NSTextAlignmentCenter;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameLabel];
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 90.0;
}


@end

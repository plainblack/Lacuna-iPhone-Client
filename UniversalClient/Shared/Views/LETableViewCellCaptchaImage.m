//
//  LETableViewCellCaptchaImage.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellCaptchaImage.h"
#import "LEMacros.h"


@implementation LETableViewCellCaptchaImage


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
	self.imageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setCapthchaImageURL:(NSString *)url {
	NSURL *imgURL = [NSURL URLWithString:url];
	NSData *data = [NSData dataWithContentsOfURL:imgURL];
	UIImage *img = [[UIImage alloc] initWithData:data];
	self.imageView.image = img;
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellCaptchaImage *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"CaptchaImageCell";
	
	LETableViewCellCaptchaImage *cell = (LETableViewCellCaptchaImage *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellCaptchaImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)] autorelease];
		cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:cell.imageView];

		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 100.0f;
}


@end

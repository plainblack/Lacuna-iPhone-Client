//
//  LEViewSectionTab.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/7/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEViewSectionTab.h"
#import "LEMacros.h"

#define SECTION_HEIGHT 44.0
#define IMAGE_HEIGHT 28.0
#define IMAGE_WIDTH 250.0


@implementation LEViewSectionTab


@synthesize label;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.autoresizesSubviews = YES;
		
		//UIImage *tabImage = [UIImage imageNamed:@"assets/ui/tab_blue.png"];
		UIImage *tabImage = [UIImage imageNamed:@"assets/iphone ui/tab.png"];
		UIImageView *tabImageView = [[[UIImageView alloc] initWithImage:tabImage] autorelease];
		tabImageView.frame = CGRectMake(20, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT);
		[self addSubview:tabImageView];
		
		self.label = [[[UILabel alloc] initWithFrame:CGRectMake(30, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH-20, IMAGE_HEIGHT)] autorelease];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = HEADER_TEXT_COLOR;
		self.label.font = HEADER_TEXT_FONT;
		[self addSubview:self.label];
    }
    return self;
}


- (void)dealloc {
	self.label = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class methods


+ (LEViewSectionTab *)tableView:(UITableView *)tableView createWithText:(NSString *)text {
	LEViewSectionTab *sectionTab = [[[LEViewSectionTab alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)] autorelease];
	sectionTab.label.text = text;
	return sectionTab;
}


+ (CGFloat)getHeight {
	return SECTION_HEIGHT;
}


@end

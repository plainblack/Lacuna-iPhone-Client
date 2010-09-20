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


@synthesize icon;
@synthesize label;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.autoresizesSubviews = YES;
		
		UIImage *tabImage = [UIImage imageNamed:@"assets/iphone ui/tab.png"];
		UIImageView *tabImageView = [[[UIImageView alloc] initWithImage:tabImage] autorelease];
		tabImageView.frame = CGRectMake(20, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT);
		[self addSubview:tabImageView];
		
		self.icon = [[[UIImageView alloc] initWithFrame:CGRectMake(25, SECTION_HEIGHT-IMAGE_HEIGHT+3, 22, 22)] autorelease];
		self.icon.backgroundColor = [UIColor clearColor];
		self.icon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		self.icon.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.icon];

		self.label = [[[UILabel alloc] initWithFrame:CGRectMake(30, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH-20, IMAGE_HEIGHT)] autorelease];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = HEADER_TEXT_COLOR;
		self.label.font = HEADER_TEXT_FONT;
		[self addSubview:self.label];
    }
    return self;
}


- (void)layoutSubviews {
	NSLog(@"layoutSubview called!");
	if (self.icon.image) {
		self.icon.frame = CGRectMake(25, SECTION_HEIGHT-IMAGE_HEIGHT+3, 22, 22);
		self.label.frame = CGRectMake(50, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH-40, IMAGE_HEIGHT);
	} else {
		self.icon.frame = CGRectMake(0, 0, 0, 0);
		self.label.frame = CGRectMake(30, SECTION_HEIGHT-IMAGE_HEIGHT, IMAGE_WIDTH-20, IMAGE_HEIGHT);
	}
}


- (void)dealloc {
	self.icon = nil;
	self.label = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class methods


+ (LEViewSectionTab *)tableView:(UITableView *)tableView withText:(NSString *)text {
	return [LEViewSectionTab tableView:tableView withText:text withIcon:nil];
}

+ (LEViewSectionTab *)tableView:(UITableView *)tableView withText:(NSString *)text withIcon:(UIImage *)icon {
	LEViewSectionTab *sectionTab = [[[LEViewSectionTab alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)] autorelease];
	sectionTab.label.text = text;
	sectionTab.icon.image = icon;
	return sectionTab;
}


+ (CGFloat)getHeight {
	return SECTION_HEIGHT;
}


@end

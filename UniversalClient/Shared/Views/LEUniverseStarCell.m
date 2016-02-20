//
//  LEUniverseCell.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEUniverseStarCell.h"
#import "Star.h"


@implementation LEUniverseStarCell


@synthesize star;

#pragma mark -
#pragma mark NSObject Methods

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;

		self->imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		self->imageView.backgroundColor = [UIColor clearColor];
		self->imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self->imageView];

		self->dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		self->dataLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self->dataLabel.font = [UIFont systemFontOfSize:10.0];
		self->dataLabel.backgroundColor = [UIColor clearColor];
		self->dataLabel.textColor = [UIColor redColor];
		self->dataLabel.numberOfLines = 0;
		self->dataLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:self->dataLabel];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTapped:)] autorelease];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
}


- (void)dealloc {
	self.star = nil;
	[self->imageView release];
	self->imageView = nil;
	[self->dataLabel release];
	self->dataLabel = nil;
	self->target = nil;
	self->callback = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setStar:(Star *)inStar {
	if (self->star != inStar) {
		[inStar retain];
		[self->star release];
		self->star = inStar;
		self->dataLabel.text = [NSString stringWithFormat:@"%@\n(%@ x %@)", self->star.name, self->star.x, self->star.y];
		self->imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/star_map/%@.png", star.color]];
	}
}


- (void)setTarget:(id)inTarget callback:(SEL)inCallback {
	self->target = inTarget;
	self->callback = inCallback;
}


- (void)reset {
	[self->star release];
	self->star = nil;
	self->imageView.image = nil;
	self->dataLabel.text = @"";
	self->target = nil;
	self->callback = nil;
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self->target performSelector:self->callback withObject:self];
}


@end

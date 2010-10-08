//
//  LEUniverseHabitablePlanetCell.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEUniverseBodyCell.h"
#import "Body.h"

@implementation LEUniverseBodyCell


@synthesize body;


#pragma mark -
#pragma mark NSObject Methods

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;

		self->imageViewBody = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		self->imageViewBody.backgroundColor = [UIColor clearColor];
		self->imageViewBody.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self->imageViewBody];

		self->imageViewAlignmentRing = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		self->imageViewAlignmentRing.backgroundColor = [UIColor clearColor];
		self->imageViewAlignmentRing.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self->imageViewAlignmentRing];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTapped:)] autorelease];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
}


- (void)dealloc {
	self.body = nil;
	[self->imageViewBody release];
	self->imageViewBody = nil;
	[self->imageViewAlignmentRing release];
	self->imageViewAlignmentRing = nil;
	self->target = nil;
	self->callback = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setBody:(Body *)inBody {
	if (self->body != inBody) {
		[inBody retain];
		[self->body release];
		self->body = inBody;
		self->imageViewBody.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/star_system/%@.png", self->body.imageName]];
		if (self->body.alignment) {
			self->imageViewAlignmentRing.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/star_map/%@.png", self->body.alignment]];
		} else {
			self->imageViewAlignmentRing.image = nil;
		}

	}
}


- (void)setTarget:(id)inTarget callback:(SEL)inCallback {
	self->target = inTarget;
	self->callback = inCallback;
}


- (void)reset {
	[self->body release];
	self->body = nil;
	self->imageViewBody.image = nil;
	self->imageViewAlignmentRing.image = nil;
	self->target = nil;
	self->callback = nil;
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self->target performSelector:self->callback withObject:self];
}


@end

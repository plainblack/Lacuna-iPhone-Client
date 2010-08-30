//
//  ItemPush.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ItemPush.h"
#import "LEMacros.h"


@implementation ItemPush

@synthesize targetId;
@synthesize items;


#pragma mark -
#pragma mark Object Methods

- (id) init {
    if (self = [super init]) {
		self.items = [NSMutableArray arrayWithCapacity:1];
	}
	
	return self;
}

- (void)dealloc {
	self.targetId = nil;
	self.items = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)addResourceType:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity {
	[self.items addObject:_dict(resourceType, @"type", quantity, @"quantity")];
}


- (void)addGlyph:(NSString *)glyphId {
	[self.items addObject:_dict(@"glyph", @"type", glyphId, @"glyph_id")];
}


- (void)addPlan:(NSString *)planId {
	[self.items addObject:_dict(@"plan", @"type", planId, @"plan_id")];
}


@end

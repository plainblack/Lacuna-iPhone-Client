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
@synthesize tradeShipId;
@synthesize stayAtTarget;


#pragma mark -
#pragma mark Object Methods

- (id) init {
    if ((self = [super init])) {
		self.items = [NSMutableArray arrayWithCapacity:1];
		self.stayAtTarget = NO;
	}
	
	return self;
}

- (void)dealloc {
	self.targetId = nil;
	self.items = nil;
	self.tradeShipId = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)addGlyph:(NSString *)glyphId {
	[self.items addObject:_dict(@"glyph", @"type", glyphId, @"glyph_id")];
}


- (void)addPlan:(NSString *)planId {
	[self.items addObject:_dict(@"plan", @"type", planId, @"plan_id")];
}


- (void)addPrisoner:(NSString *)prisonerId {
	[self.items addObject:_dict(@"prisoner", @"type", prisonerId, @"prisoner_id")];
}


- (void)addResourceType:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity {
	[self.items addObject:_dict(resourceType, @"type", quantity, @"quantity")];
}


- (void)addShip:(NSString *)shipId {
	[self.items addObject:_dict(@"ship", @"type", shipId, @"ship_id")];
}


@end

//
//  MarketTrade.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MarketTrade.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation MarketTrade


@synthesize	id;
@synthesize	dateOffered;
@synthesize	askEssentia;
@synthesize	offerTexts;
@dynamic offerText;
@synthesize offer;
@synthesize bodyId;
@synthesize empireId;
@synthesize empireName;
@synthesize tradeShipId;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.dateOffered = nil;
	self.askEssentia = nil;
	self.offerTexts = nil;
	self.offer = nil;
	self.bodyId = nil;
	self.empireId = nil;
	self.empireName = nil;
	self.tradeShipId = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, dateOffered:%@, askEssentia:%@, bodyId:%@, empireId:%@, empireName:%@, tradeShipId:%@, offerTexts:%@, offer:%@",
			self.id, self.dateOffered, self.askEssentia, self.bodyId, self.empireId, self.empireName, self.tradeShipId, self.offerTexts, self.offer];
}

#pragma mark -
#pragma mark Property Methods

- (NSString *)offerText {
	NSString *tmp = [self.offerTexts componentsJoinedByString:@"; "];
	tmp = [tmp stringByReplacingOccurrencesOfString:@".;" withString:@";"];
	return tmp;
}

#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
    NSLog(@"Market Trade Data: %@", data);
	self.id = [Util idFromDict:data named:@"id"];
	self.dateOffered = [Util date:[data objectForKey:@"date_offered"]];
	self.askEssentia = [Util asNumber:[data objectForKey:@"ask"]];
    id tmp = [data objectForKey:@"offer"];
    if ([tmp isKindOfClass:[NSArray class]]) {
        self.offerTexts = tmp;
    } else {
        self.offerTexts = _array(tmp);
    }

	NSMutableDictionary *bodyData = [data objectForKey:@"body"];
	if (!bodyData) {
		NSLog(@"Trade Body Data Returned as body_id again!");
		bodyData = [data objectForKey:@"body_id"];
	}
	if (bodyData) {
		self.bodyId = [Util idFromDict:bodyData named:@"id"];
	}
	
	NSMutableDictionary *empireData = [data objectForKey:@"empire"];
	if (empireData) {
		self.empireId = [Util idFromDict:empireData named:@"id"];
		self.empireName = [empireData objectForKey:@"name"];
	}
}

- (void)addResource:(NSString *)type amount:(NSDecimalNumber *)amount {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(type, @"type", amount, @"quantity")];
}


- (void)addGlyph:(NSString *)glyphId {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(@"glyph", @"type", glyphId, @"glyph_id")];
}


- (void)addPlan:(NSString *)planId {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(@"plan", @"type", planId, @"plan_id")];
}


- (void)addPrisoner:(NSString *)prisonerId {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(@"prisoner", @"type", prisonerId, @"prisoner_id")];
}


- (void)addSpy:(NSString *)prisonerId {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(@"spy", @"type", prisonerId, @"spy_id")];
}


- (void)addShip:(NSString *)shipId {
	if (!self.offer) {
		self.offer = [NSMutableArray arrayWithCapacity:5];
	}
	[self.offer addObject:_dict(@"ship", @"type", shipId, @"ship_id")];
}


@end

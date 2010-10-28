//
//  Trade.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Trade.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation Trade


@synthesize	id;
@synthesize	dateOffered;
@synthesize	askType;
@synthesize	askQuantity;
@synthesize	askDescription;
@synthesize	offerType;
@synthesize	offerQuantity;
@synthesize offerGlyphId;
@synthesize offerPlanId;
@synthesize offerPrisonerId;
@synthesize offerShipId;
@synthesize	offerDescription;
@synthesize tradeShipId;
@synthesize bodyId;
@synthesize empireId;
@synthesize empireName;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.dateOffered = nil;
	self.askType = nil;
	self.askQuantity = nil;
	self.askDescription = nil;
	self.offerType = nil;
	self.offerQuantity = nil;
	self.offerGlyphId = nil;
	self.offerPlanId = nil;
	self.offerPrisonerId = nil;
	self.offerShipId = nil;
	self.offerDescription = nil;
	self.tradeShipId = nil;
	self.bodyId = nil;
	self.empireId = nil;
	self.empireName = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, dateOffered:%@, askType:%@, askQuantity:%@, askDescription:%@, offerType:%@, offerQuantity:%@, offerDescription:%@, tradeShipId:%@, bodyId:%@, empireId:%@, empireName:%@",
			self.id, self.dateOffered, self.askType, self.askQuantity, self.askDescription, self.offerType, self.offerQuantity, self.offerDescription, self.tradeShipId, self.bodyId, self.empireId, self.empireName];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.dateOffered = [Util date:[data objectForKey:@"date_offered"]];
	self.askType = [data objectForKey:@"ask_type"];
	self.askQuantity = [Util asNumber:[data objectForKey:@"ask_quantity"]];
	self.askDescription = [data objectForKey:@"ask_description"];
	self.offerType = [data objectForKey:@"offer_type"];
	self.offerQuantity = [Util asNumber:[data objectForKey:@"offer_quantity"]];
	self.offerDescription = [data objectForKey:@"offer_description"];
	
	NSMutableDictionary *bodyData = [data objectForKey:@"body"];
	if (!bodyData) {
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


@end

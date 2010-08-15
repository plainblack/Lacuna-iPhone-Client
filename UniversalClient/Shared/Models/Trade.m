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
@synthesize	offerDescription;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.dateOffered = nil;
	self.askType = nil;
	self.askQuantity = nil;
	self.askDescription = nil;
	self.offerType = nil;
	self.offerQuantity = nil;
	self.offerDescription = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, dateOffered:%@, askType:%@, askQuantity:%@, askDescription:%@, askType:%@, askQuantity:%@, askDescription:%@",
			self.id, self.dateOffered, self.askType, self.askQuantity, self.askDescription, self.offerType, self.offerQuantity, self.offerDescription];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	NSLog(@"Trade Data: %@", data);
	
	self.id = [data objectForKey:@"id"];
	self.dateOffered = [Util date:[data objectForKey:@"date_offered"]];
	self.askType = [data objectForKey:@"ask_type"];
	self.askQuantity = [Util asNumber:[data objectForKey:@"ask_quantity"]];
	self.askDescription = [data objectForKey:@"ask_description"];
	self.offerType = [data objectForKey:@"offer_type"];
	self.offerQuantity = [Util asNumber:[data objectForKey:@"offer_quantity"]];
	self.offerDescription = [data objectForKey:@"offer_description"];
}


@end

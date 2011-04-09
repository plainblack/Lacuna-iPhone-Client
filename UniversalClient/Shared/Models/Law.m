//
//  Law.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "Law.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation Law


@synthesize id;
@synthesize name;
@synthesize descriptionText;
@synthesize dateEnacted;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.descriptionText = nil;
	self.dateEnacted = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, description:%@, dateEnacted:%@",
            self.id, self.name, self.descriptionText, self.dateEnacted];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.descriptionText = [data objectForKey:@"description"];
	self.dateEnacted = [Util date:[data objectForKey:@"date_enacted"]];
}


@end

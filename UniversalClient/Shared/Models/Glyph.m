//
//  Glyph.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Glyph.h"
#import "Util.h"


@implementation Glyph


@synthesize id;
@synthesize type;
@dynamic imageName;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.type = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, type:%@", self.id, self.type];
}


#pragma mark -
#pragma mark Instance Methods

- (NSString *)imageName {
	return [NSString stringWithFormat:@"/assets/glyphs/%@.png", self.type];
}


- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.type = [data objectForKey:@"type"];
}


@end

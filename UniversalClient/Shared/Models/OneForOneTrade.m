//
//  OneForOneTrade.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "OneForOneTrade.h"


@implementation OneForOneTrade

@synthesize haveResourceType;
@synthesize wantResourceType;
@synthesize quantity;


#pragma mark -
#pragma mark Object Methods

- (id) init {
    if (self = [super init]) {
	}
	
	return self;
}

- (void)dealloc {
	self.haveResourceType = nil;
	self.wantResourceType = nil;
	self.quantity = nil;
	[super dealloc];
}
@end

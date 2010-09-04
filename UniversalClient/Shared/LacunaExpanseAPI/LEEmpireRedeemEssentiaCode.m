//
//  LEEmpireRedeemEssentiaCode.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireRedeemEssentiaCode.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireRedeemEssentiaCode


@synthesize code;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget code:(NSString *)inCode {
	self.code = inCode;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.code);
}


- (void)processSuccess {
	NSLog(@"Redeem Essentia Code Response: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"redeem_essentia_code";
}


- (void)dealloc {
	self.code = nil;
	[super dealloc];
}


@end

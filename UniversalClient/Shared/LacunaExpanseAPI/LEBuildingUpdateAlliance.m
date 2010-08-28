//
//  LEBuildingUpdateAlliance.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingUpdateAlliance.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingUpdateAlliance


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize forumUri;
@synthesize description;
@synthesize announcements;
@synthesize allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl forumUri:(NSString *)inForumUri description:(NSString *)inDescription announcements:(NSString *)inAnnouncements {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.forumUri = inForumUri;
	self.description = inDescription;
	self.announcements = inAnnouncements;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
	if (self.forumUri) {
		[params setObject:self.forumUri forKey:@"forum_uri"];
	}
	if (self.description) {
		[params setObject:self.description forKey:@"description"];
	}
	if (self.announcements) {
		[params setObject:self.announcements forKey:@"announcements"];
	}
	NSLog(@"Update Alliance Params: %@", params);
	return _array([Session sharedInstance].sessionId, self.buildingId, params);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.allianceStatus = [result objectForKey:@"alliance_status"];
	if (!self.allianceStatus) {
		self.allianceStatus = [result objectForKey:@"alliance"];
	}
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"update_alliance";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.forumUri = nil;
	self.description = nil;
	self.announcements = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end

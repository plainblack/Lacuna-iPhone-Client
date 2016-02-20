//
//  Servers.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Servers.h"
#import "JSON.h"


@implementation Servers


@synthesize serverList;


#pragma mark  -
#pragma mark NSObject Methods

- (void)dealloc {
	self.serverList = nil;
	[super dealloc];
}


#pragma mark - 
#pragma mark Instance Methods

- (void)readServers {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"servers" ofType:@"json"];
	if (filePath) {
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		if (myText) {
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			id obj = [parser objectWithString:myText];
			self.serverList = obj;
			[parser release];
		}
	}
}


- (void)loadServers {
	NSError *error = nil;
	NSString *myText = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.lacunaexpanse.com/servers.json"] encoding:NSUTF8StringEncoding error:&error];
	if (myText) {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		id obj = [parser objectWithString:myText];
		self.serverList = obj;
		[parser release];
	} else {
		NSLog(@"Error getting servers.json");
		self.serverList = [NSMutableArray array];
	}
}


@end

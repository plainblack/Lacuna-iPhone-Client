//
//  Prisoner.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Prisoner.h"
#import "Util.h"


@implementation Prisoner


@synthesize id;
@synthesize name;
@synthesize level;
@synthesize sentenceExpiresOn;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, level: %@, sentenceExpiresOn:%@", 
			self.id, self.name, self.level, self.sentenceExpiresOn];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.level = nil;
	self.sentenceExpiresOn = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)prisonerData {
	self.id = [Util idFromDict:prisonerData named:@"id"];
	self.name = [prisonerData objectForKey:@"name"];
	self.level = [Util asNumber:[prisonerData objectForKey:@"level"] ];
	NSString *sentenceExpiresString = [prisonerData objectForKey:@"sentence_expires"];
	if (sentenceExpiresString) {
		self.sentenceExpiresOn = [Util date:sentenceExpiresString];
	} else {
		self.sentenceExpiresOn = nil;
	}

}


- (BOOL)tick:(NSInteger)interval {
	return [self.sentenceExpiresOn compare:[NSDate date]] != NSOrderedAscending;
}


@end

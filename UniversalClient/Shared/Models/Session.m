//
//  Session.m
//  DKTest
//
//  Created by Kevin Runde on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Session.h"
#import "DKDeferred+JSON.h"
#import "LEEmpireLogin.h"
#import "LEEmpireLogout.h"
#import "LEMacros.h"
#import "KeychainItemWrapper.h"


static Session *sharedSession = nil;


@implementation Session


@synthesize sessionId;
@synthesize empireData;
@synthesize isLoggedIn;
@synthesize mapCenterX;
@synthesize mapCenterY;
@synthesize mapCenterZ;
@synthesize numNewMessages;
@synthesize empireList;
@synthesize lastMessageAt;


+ (Session *)sharedInstance {
    if (sharedSession == nil) {
        sharedSession = [[super allocWithZone:NULL] init];
    }
    return sharedSession;
}


+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)retain {
    return self;
}


- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}


- (void)release {
    //do nothing
}


- (id)autorelease {
    return self;
}


- (id)init {
	NSLog(@"Session init called");
	self.mapCenterX = [NSNumber numberWithInt:0];
	self.mapCenterY = [NSNumber numberWithInt:0];
	self.mapCenterZ = [NSNumber numberWithInt:0];

	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
	self.empireList = [NSMutableArray arrayWithContentsOfFile:empireListFileName];
	if (!self.empireList) {
		self.empireList = [NSMutableArray arrayWithCapacity:1];
	}

	return self;
}


- (void)dealloc {
	self.sessionId = nil;
	self.empireData = nil;
	self.mapCenterX = nil;
	self.mapCenterY = nil;
	self.mapCenterZ = nil;
	self.empireList = nil;
	self.numNewMessages = nil;
	self.lastMessageAt = nil;
	[super dealloc];
}


- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
	NSLog(@"User: %@, pass: %@", username, password);
	[[[LEEmpireLogin alloc] initWithCallback:@selector(loggedIn:) target:self username:username password:password] autorelease];
}


- (void)logout {
	[[[LEEmpireLogout alloc] initWithCallback:@selector(loggedOut:) target:self sessionId:self.sessionId] autorelease];
}


- (void)updateStatus {
	id service = [DKDeferred jsonService:@"https://game.lacunaexpanse.com/empire/" name:@"get_full_status"];
	DKDeferred *d = [service :array_([Session sharedInstance].sessionId)];
	[d addCallback:callbackTS(self, fullStatusUpdate:)];
	[d addErrback:callbackTS(self, apiError:)];
}


- (id)loggedIn:(LEEmpireLogin *)request {
	if ([request wasError]) {
		[request markErrorHandled];

		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not login" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];

		self.sessionId = nil;
		self.empireData = nil;
	} else {
		KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:request.username accessGroup:nil] autorelease];
		[keychainItemWrapper resetKeychainItem];
		if (![request.username isEqualToString:@"bob57"]) {
			[keychainItemWrapper setObject:request.username forKey:(id)kSecAttrAccount];
			[keychainItemWrapper setObject:request.password forKey:(id)kSecValueData];
		}
		BOOL found = NO;
		for (NSDictionary *empire in self.empireList) {
			if ([[empire objectForKey:@"username"] isEqualToString:request.username]){
				found = YES;
			}
		}
		if (!found) {
			[self.empireList addObject:dict_(request.username, @"username")];
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentFolderPath = [searchPaths objectAtIndex:0];
			NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
			[self.empireList writeToFile:empireListFileName atomically:YES];
		}
	
		
		self.sessionId = request.sessionId;
		self.empireData = request.empireData;
		NSString *homePlanetId = [self.empireData objectForKey:@"home_planet_id"];
		NSDictionary *homePlanet = [[self.empireData objectForKey:@"planets"] objectForKey:homePlanetId];
		self.mapCenterX = [homePlanet objectForKey:@"x"];
		self.mapCenterY = [homePlanet objectForKey:@"y"];
		self.mapCenterZ = [homePlanet objectForKey:@"z"];
		self.isLoggedIn = TRUE;
		
		NSLog(@"Session ID: %@", self.sessionId);
	}
	
	return nil;
}


- (id)loggedOut:(LEEmpireLogout *)request {
	if ([request result]) {
		self.sessionId = nil;
		self.empireData = nil;
		self.isLoggedIn = FALSE;
		self.numNewMessages = 0;
	} else {
		NSLog(@"Logout failed");
	}
	
	return nil;
}


- (id)fullStatusUpdate:(id)results {
	NSLog(@"fullStatusUpdate success: %@", results);
	self.empireData = [[results objectForKey:@"result"] objectForKey:@"empire"];
	
	return nil;
}


- (void)forgetEmpireNamed:(NSString *)empireName {
	NSDictionary *foundEmpire;
	for (NSDictionary *empire in self.empireList) {
		if ([[empire objectForKey:@"username"] isEqualToString:empireName]){
			foundEmpire = empire;
		}
	}
	if (foundEmpire) {
		[self.empireList removeObject:foundEmpire];
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
		[self.empireList writeToFile:empireListFileName atomically:YES];
	}
}


#pragma mark -
#pragma mark SPECIAL Setters

- (void)setNumNewMessages:(NSNumber *)newNumNewMessages {
	NSNumber *tmp = numNewMessages;
	if (numNewMessages) {
		[numNewMessages release];
		numNewMessages = nil;
	}
	numNewMessages = newNumNewMessages;
	if (numNewMessages) {
		[numNewMessages retain];
		if ( tmp && ([tmp compare:numNewMessages]==NSOrderedAscending) ) {
			self.lastMessageAt = [NSDate date];
		}
	}
}
@end

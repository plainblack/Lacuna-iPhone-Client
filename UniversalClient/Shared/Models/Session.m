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
#import "Util.h"


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
@synthesize serverVersion;


#pragma mark --
#pragma mark Singleton methods

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

#pragma mark --
#pragma mark Live Cycle methods

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
	self.lastMessageAt = nil;
	self.serverVersion = nil;
	[super dealloc];
}

#pragma mark --
#pragma mark Instance methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
	[[[LEEmpireLogin alloc] initWithCallback:@selector(loggedIn:) target:self username:username password:password] autorelease];
}


- (void)logout {
	[[[LEEmpireLogout alloc] initWithCallback:@selector(loggedOut:) target:self sessionId:self.sessionId] autorelease];
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


- (void)processStatus:(NSDictionary *)status {
	if (status && [status respondsToSelector:@selector(objectForKey:)]) {
		NSDictionary *serverStatus = [status objectForKey:@"server"];
		NSLog(@"server status: %@", serverStatus);
		if (serverStatus) {
			NSString *newServerVersion = [serverStatus objectForKey:@"version"];
			if (self.serverVersion) {
				if (![self.serverVersion isEqual:newServerVersion]) {
					NSLog(@"Server version changed from: %@ to %@", self.serverVersion, newServerVersion);
					self.serverVersion = newServerVersion;
				}
			} else {
				NSLog(@"Setting server version to %@", newServerVersion);
				self.serverVersion = newServerVersion;
			}
		}
		
		NSDictionary *empireStatus = [status objectForKey:@"empire"];
		NSLog(@"empireStatus: %@", empireStatus);
		if (empireStatus) {
			NSInteger oldNumNewMessages = intv_([self.empireData objectForKey:@"has_new_messages"]);
			NSInteger newNumNewMessages = intv_([empireStatus objectForKey:@"has_new_messages"]);
			self.empireData = empireStatus;
			if (oldNumNewMessages != newNumNewMessages) {
				self.numNewMessages = newNumNewMessages;
			}
			NSDictionary *newestMessage = [empireStatus objectForKey:@"most_recent_message"];
			if (newestMessage && (id)newestMessage != [NSNull null]) {
				NSString *dateReceivedString = [newestMessage objectForKey:@"date_received"];
				if (dateReceivedString) {
					NSLog(@"Setting lastMessageAt to: %@", dateReceivedString);
					self.lastMessageAt = [Util date:dateReceivedString];
				}else {
					NSLog(@"date_received was not their");
				}
			}else {
				NSLog(@"most_recent_message was not their");
			}
			
			self.numNewMessages = intv_([empireStatus objectForKey:@"has_new_messages"]);
		}
	}
}


#pragma mark --
#pragma mark Callback methods

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
		//[keychainItemWrapper resetKeychainItem]; //I removed this and now things work on teras phone maybe??
		[keychainItemWrapper setObject:request.username forKey:(id)kSecAttrAccount];
		[keychainItemWrapper setObject:request.password forKey:(id)kSecValueData];
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

@end

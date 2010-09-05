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
#import "LEBodyStatus.h"
#import "LEMacros.h"
#import "KeychainItemWrapper.h"
#import "Util.h"


static Session *sharedSession = nil;


@implementation Session


@synthesize sessionId;
@synthesize isLoggedIn;
@synthesize savedEmpireList;
@synthesize serverVersion;
@synthesize empire;
@synthesize body;
@synthesize lastTick;
@synthesize serverUri;


#pragma mark -
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

#pragma mark -
#pragma mark Live Cycle methods

- (id)init {
    if (self = [super init]) {
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
		self.savedEmpireList = [NSMutableArray arrayWithContentsOfFile:empireListFileName];
		if (!self.savedEmpireList) {
			self.savedEmpireList = [NSMutableArray arrayWithCapacity:1];
		}
		
		self.lastTick = [NSDate date];
		self->timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES] retain];
	}

	return self;
}


- (void)dealloc {
	self.sessionId = nil;
	self.empire = nil;
	self.body = nil;
	self.savedEmpireList = nil;
	self.serverVersion = nil;
	self.lastTick = nil;
	[self->timer invalidate];
	[self->timer release];
	self->timer = nil;
	self.serverUri = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Instance methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
	[[[LEEmpireLogin alloc] initWithCallback:@selector(loggedIn:) target:self username:username password:password] autorelease];
}


- (void)reloginTarget:(id)target selector:(SEL)selector {
	NSLog(@"Attempting to relogin");
	self->reloginTarget = [target retain];
	self->reloginSelector = selector;
	NSString *username = self.empire.name;
	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:username accessGroup:nil] autorelease];				
	NSString *password = [keychainItemWrapper objectForKey:(id)kSecValueData];
	[[[LEEmpireLogin alloc] initWithCallback:@selector(reloggedIn:) target:self username:username password:password] autorelease];
}

- (void)logout {
	[[[LEEmpireLogout alloc] initWithCallback:@selector(loggedOut:) target:self sessionId:self.sessionId] autorelease];
	self.sessionId = nil;
	self.empire = nil;
	self.body = nil;
	self.isLoggedIn = NO;
	self.serverUri = nil;
}


- (void)forgetEmpireNamed:(NSString *)empireName {
	NSDictionary *foundEmpire;
	for (NSDictionary *savedEmpire in self.savedEmpireList) {
		if ([[savedEmpire objectForKey:@"username"] isEqualToString:empireName]){
			foundEmpire = savedEmpire;
		}
	}
	if (foundEmpire) {
		[self.savedEmpireList removeObject:foundEmpire];
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
		[self.savedEmpireList writeToFile:empireListFileName atomically:YES];
	}
}


- (void)processStatus:(NSDictionary *)status {
	if (status && [status respondsToSelector:@selector(objectForKey:)]) {
		NSDictionary *serverStatus = [status objectForKey:@"server"];
		if (serverStatus) {
			NSString *newServerVersion = [serverStatus objectForKey:@"version"];
			if (self.serverVersion) {
				if (![self.serverVersion isEqual:newServerVersion]) {
					NSLog(@"Server version changed from: %@ to %@", self.serverVersion, newServerVersion);
					self.serverVersion = newServerVersion;
				}
			} else {
				self.serverVersion = newServerVersion;
				NSLog(@"Server version is: %@", self.serverVersion);
			}
		}
		
		NSDictionary *empireStatus = [status objectForKey:@"empire"];
		if (empireStatus) {
			[self.empire parseData:empireStatus];
		}

		NSDictionary *bodyStatus = [status objectForKey:@"body"];
		if (bodyStatus) {
			[self.body parseData:bodyStatus];
		}
	}
}


- (void) loadBody:(NSString *)bodyId {
	if (self.body) {
		self.body.buildingMap = nil;
	}
	[[[LEBodyStatus alloc] initWithCallback:@selector(bodyLoaded:) target:self bodyId:bodyId] autorelease];
}


- (void)loggedInEmpireData:(NSDictionary *)inEmpireData sessionId:(NSString *)inSessionId password:(NSString *)inPassword {
	NSString *username = [inEmpireData objectForKey:@"name"];
	[self saveToKeyChainForUsername:username password:inPassword];
	
	BOOL found = NO;
	for (NSDictionary *savedEmpire in self.savedEmpireList) {
		if ([[savedEmpire objectForKey:@"username"] isEqualToString:username]){
			found = YES;
		}
	}
	if (!found) {
		[self.savedEmpireList addObject:dict_(username, @"username")];
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
		[self.savedEmpireList writeToFile:empireListFileName atomically:YES];
	}

	self.sessionId = inSessionId;
	self.empire = [[Empire alloc] init];
	[self.empire parseData:inEmpireData];
	self.isLoggedIn = TRUE;
}


- (void)saveToKeyChainForUsername:(NSString *)username password:(NSString *)password {
	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:username accessGroup:nil] autorelease];
	[keychainItemWrapper setObject:username forKey:(id)kSecAttrAccount];
	[keychainItemWrapper setObject:password forKey:(id)kSecValueData];
	[keychainItemWrapper setObject:self.serverUri forKey:(id)kSecAttrService];
}


#pragma mark -
#pragma mark Callback methods

- (void)handleTimer:(NSTimer *)theTimer {
	NSDate *now = [NSDate date];
	if(self.body) {
		NSTimeInterval interval = [now timeIntervalSinceDate: self.lastTick];
		NSInteger intervalInt = round(interval);
		[self.body tick:intervalInt];
	}
	self.lastTick = now;
}


- (id)loggedIn:(LEEmpireLogin *)request {
	if ([request wasError]) {
		[request markErrorHandled];

		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not login" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];

		self.sessionId = nil;
		self.empire = nil;
	} else {
		[self loggedInEmpireData:request.empireData sessionId:request.sessionId password:request.password];
	}
	
	return nil;
}


- (id)reloggedIn:(LEEmpireLogin *)request {
	if ([request wasError]) {
		[request markErrorHandled];
		
		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not relogin" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		
		self.sessionId = nil;
		self.empire = nil;
		self.isLoggedIn = NO;
	} else {
		self.sessionId = request.sessionId;
		self.empire = [[Empire alloc] init];
		[self.empire parseData:request.empireData];
		//Don't change self.isLoggedIn becuase well it should stay logged in
	}
	[self->reloginTarget performSelector:self->reloginSelector];
	[self->reloginTarget release];
	self->reloginTarget = nil;
	
	return nil;
}


- (id)loggedOut:(LEEmpireLogout *)request {
	return nil;
}


- (id)bodyLoaded:(LEBodyStatus *)request {
	if (self.body) {
		[self.body parseData:request.body];
	} else {
		Body *newBody = [[[Body alloc] init] autorelease];
		[newBody parseData:request.body];
		self.body = newBody;
	}

	
	return nil;
}


@end

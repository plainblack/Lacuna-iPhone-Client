//
//  Session.m
//  DKTest
//
//  Created by Kevin Runde on 1/30/10.
//  Copyright 2010 n/a. rights reserved.
//

#import "Session.h"
#import "LEEmpireLogin.h"
#import "LEEmpireLogout.h"
#import "LEBodyStatus.h"
#import "LEMacros.h"
#import "KeychainItemWrapper.h"
#import "Util.h"
#import "JSON.h"
#import "AppDelegate_Phone.h"


//static Session *sharedSession = nil;


@implementation Session


@synthesize sessionId;
@synthesize isLoggedIn;
@synthesize savedEmpireList;
@synthesize serverVersion;
@synthesize rpcLimit;
@synthesize empire;
@synthesize body;
@synthesize lastTick;
@synthesize serverUri;
@synthesize itemDescriptions;
@synthesize lacunanMessageId;
@synthesize universeMinX;
@synthesize universeMaxX;
@synthesize universeMinY;
@synthesize universeMaxY;


#pragma mark -
#pragma mark Live Cycle methods

- (id)init {
    if ((self = [super init])) {
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
		self.savedEmpireList = [NSMutableArray arrayWithContentsOfFile:empireListFileName];
		if (!self.savedEmpireList) {
			self.savedEmpireList = [NSMutableArray arrayWithCapacity:1];
		}

		[self readItemDescriptions];
		
		self.lastTick = [NSDate date];
		self->timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES] retain];
	}

	return self;
}


- (void)dealloc {
	self.sessionId = nil;
	NSLog(@"dealloc unset empire");
	self.empire = nil;
	self.body = nil;
	self.savedEmpireList = nil;
	self.serverVersion = nil;
	self.rpcLimit = nil;
	self.lastTick = nil;
	[self->timer invalidate];
	[self->timer release];
	self->timer = nil;
	self.serverUri = nil;
	self.itemDescriptions = nil;
	self.lacunanMessageId = nil;
	self.universeMinX = nil;
	self.universeMaxX = nil;
	self.universeMinY = nil;
	self.universeMaxY = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
	[[[LEEmpireLogin alloc] initWithCallback:@selector(loggedIn:) target:self username:username password:password] autorelease];
}


- (void)reloginTarget:(id)target selector:(SEL)selector {
	NSLog(@"Attempting to relogin");
	if (self.empire) {
		self->reloginTarget = [target retain];
		self->reloginSelector = selector;
		NSString *username = self.empire.name;
		if (self.empire.name) {
			KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithUsername:username serverUri:self.serverUri accessGroup:nil] autorelease];				
			NSString *password = [keychainItemWrapper objectForKey:(id)kSecValueData];
			[[[LEEmpireLogin alloc] initWithCallback:@selector(reloggedIn:) target:self username:username password:password] autorelease];
		} else {
			NSLog(@"Empire's username is null. HOW?");
			[self logout];
		}
	} else {
		[target performSelector:@selector(cancel)];
	}
}

- (void)logout {
	[[[LEEmpireLogout alloc] initWithCallback:@selector(loggedOut:) target:self sessionId:self.sessionId] autorelease];
	self.isLoggedIn = NO;
	self.sessionId = nil;
	self.empire = nil;
	self.body = nil;
	self.serverUri = nil;
}


- (void)forgetEmpireNamed:(NSString *)empireName {
	NSDictionary *foundEmpire = nil;
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
            id obj = [serverStatus objectForKey:@"version"];
			NSString *newServerVersion = nil;
            if ([obj isKindOfClass:[NSString class]]) {
                newServerVersion = obj;
            } else {
                newServerVersion = [obj stringValue];
            }
			if (self.serverVersion) {
				if (![self.serverVersion isEqual:newServerVersion]) {
					NSLog(@"Server version changed from: %@ to %@", self.serverVersion, newServerVersion);
					self.serverVersion = newServerVersion;
					NSArray *parts = [newServerVersion componentsSeparatedByString:@"."];
					if ([parts count] == 1) {
						NSInteger majorVersion = [[parts objectAtIndex:0] intValue];
						if (majorVersion > SERVER_MAJOR) {
							UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server is reporting a Major Version upgrade. This version of the client will not work with it. Server major sersion is %li, but this client is compatible with major version %i.", (long)majorVersion, SERVER_MAJOR] preferredStyle:UIAlertControllerStyleAlert];
							UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
												 { [av dismissViewControllerAnimated:YES completion:nil]; }];
							[av addAction: ok];
						}
                    } else if ([parts count] == 2) {
						NSInteger majorVersion = [[parts objectAtIndex:0] intValue];
						if (majorVersion > SERVER_MAJOR) {
							UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server is reporting a Major Version upgrade. This version of the client will not work with it. Server major sersion is %li, but this client is compatible with major version %i.", (long)majorVersion, SERVER_MAJOR] preferredStyle:UIAlertControllerStyleAlert];
							UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
												 { [av dismissViewControllerAnimated:YES completion:nil]; }];
							[av addAction: ok];
						}
					} else {
						UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server version is invalid. Please report this! Server Version %@", newServerVersion] preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [av dismissViewControllerAnimated:YES completion:nil]; }];
						[av addAction: ok];
					}
				}
			} else {
				self.serverVersion = newServerVersion;
				NSLog(@"Server version is: %@", self.serverVersion);
				NSArray *parts = [newServerVersion componentsSeparatedByString:@"."];
                if ([parts count] == 1) {
                    NSInteger majorVersion = [[parts objectAtIndex:0] intValue];
                    if (majorVersion > SERVER_MAJOR) {
						UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server is reporting a Major Version upgrade. This version of the client will not work with it. Server major sersion is %li, but this client is compatible with major version %i.", (long)majorVersion, SERVER_MAJOR] preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [av dismissViewControllerAnimated:YES completion:nil]; }];
						[av addAction: ok];
                    }
                } else if ([parts count] == 2) {
					NSInteger majorVersion = [[parts objectAtIndex:0] intValue];
					if (majorVersion > SERVER_MAJOR) {
						UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server is reporting a Major Version upgrade. This version of the client will not work with it. Server major sersion is %li, but this client is compatible with major version %i.", (long)majorVersion, SERVER_MAJOR] preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [av dismissViewControllerAnimated:YES completion:nil]; }];
						[av addAction: ok];
					}
				} else {
					UIAlertController *av = [UIAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"The server version is invalid. Please report this! Server Version %@", newServerVersion] preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
										 { [av dismissViewControllerAnimated:YES completion:nil]; }];
					[av addAction: ok];
				}
			}
			self.rpcLimit = [Util asNumber:[serverStatus objectForKey:@"rpc_limit"]];
			
			NSMutableDictionary *starMapSize = [serverStatus objectForKey:@"star_map_size"];
			if (starMapSize) {
				self.universeMinX = [Util asNumber:[[starMapSize objectForKey:@"x"] objectAtIndex:0]];
				self.universeMaxX = [Util asNumber:[[starMapSize objectForKey:@"x"] objectAtIndex:1]];
				self.universeMinY = [Util asNumber:[[starMapSize objectForKey:@"y"] objectAtIndex:0]];
				self.universeMaxY = [Util asNumber:[[starMapSize objectForKey:@"y"] objectAtIndex:1]];
			}
		}
		
		NSDictionary *empireStatus = [status objectForKey:@"empire"];
		if (empireStatus) {
			[self.empire parseData:empireStatus];
		}

		NSMutableDictionary *bodyStatus = [status objectForKey:@"body"];
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
	
	[self updatedSavedEmpire:username uri:self.serverUri];
	
	self.sessionId = inSessionId;
	self.empire = [[[Empire alloc] init] autorelease];
	[self.empire parseData:inEmpireData];
	self.isLoggedIn = TRUE;
}


- (void)saveToKeyChainForUsername:(NSString *)username password:(NSString *)password {
	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithUsername:username serverUri:self.serverUri accessGroup:nil] autorelease];
	//[keychainItemWrapper setObject:username forKey:(id)kSecAttrAccount];
	[keychainItemWrapper setObject:password forKey:(id)kSecValueData];
	//[keychainItemWrapper setObject:self.serverUri forKey:(id)kSecAttrService];
}


- (void)readItemDescriptions {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"assets/resources" ofType:@"json"];
	if (filePath) {
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		if (myText) {
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			id obj = [parser objectWithString:myText];
			self.itemDescriptions = obj;
			[parser release];
		}
	}
}


- (NSString *)descriptionForBuilding:(NSString *)buildingUrl {
	NSString *description = nil;
	NSDictionary *buildings = [self.itemDescriptions objectForKey:@"buildings"];
	if (buildings) {
		NSDictionary *item = [buildings objectForKey:buildingUrl];
		if (item) {
			description = [item objectForKey:@"description"];
		}
	}
	if (description) {
		return description;
	} else {
		return @"Not Available";
	}
}


- (NSString *)wikiLinkForBuilding:(NSString *)buildingUrl {
	NSString *wikiUrl = nil;
	NSDictionary *buildings = [self.itemDescriptions objectForKey:@"buildings"];
	if (buildings) {
		NSDictionary *item = [buildings objectForKey:buildingUrl];
		if (item) {
			wikiUrl = [item objectForKey:@"wiki"];
		}
	}
	if (wikiUrl) {
		return wikiUrl;
	} else {
		return @"https://community.lacunaexpanse.com/wiki";
	}
}


- (NSString *)descriptionForShip:(NSString *)shipType {
	NSString *description = nil;
	NSDictionary *ships = [self.itemDescriptions objectForKey:@"ships"];
	if (ships) {
		NSDictionary *item = [ships objectForKey:shipType];
		if (item) {
			description = [item objectForKey:@"description"];
		}
	}
	if (description) {
		return description;
	} else {
		return @"Not Available";
	}
}


- (NSString *)wikiLinkForShip:(NSString *)shipType {
	NSString *wikiUrl = nil;
	NSDictionary *ships = [self.itemDescriptions objectForKey:@"ships"];
	if (ships) {
		NSDictionary *item = [ships objectForKey:shipType];
		if (item) {
			wikiUrl = [item objectForKey:@"wiki"];
		}
	}
	if (wikiUrl) {
		return wikiUrl;
	} else {
		return @"Not Available";
	}
}


- (void)updatedSavedEmpire:(NSString *)empireName uri:(NSString *)uri {
	BOOL found = NO;
	for (NSMutableDictionary *savedEmpire in self.savedEmpireList) {
		if ([[savedEmpire objectForKey:@"username"] isEqualToString:empireName] && [[savedEmpire objectForKey:@"uri"] isEqualToString:uri]){
			found = YES;
			[savedEmpire setObject:uri forKey:@"uri"];
		}
	}
	if (!found) {
		[self.savedEmpireList addObject:_dict(empireName, @"username", uri, @"uri")];
	}
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
	[self.savedEmpireList writeToFile:empireListFileName atomically:YES];
}


- (void)renameSavedEmpireNameFrom:(NSString *)oldEmpireName to:(NSString *)newEmpireName {
	for (NSMutableDictionary *savedEmpire in self.savedEmpireList) {
		if ([[savedEmpire objectForKey:@"username"] isEqualToString:oldEmpireName]){
			[savedEmpire setObject:newEmpireName forKey:@"username"];
		}
	}
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	NSString *empireListFileName = [documentFolderPath stringByAppendingPathComponent:@"empireList.dat"];
	[self.savedEmpireList writeToFile:empireListFileName atomically:YES];
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
		
		if ([request errorCode] == 1100) {
			AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
			[appDelegate restartCreateEmpireId:[Util idFromDict:[request errorData] named:@"empire_id"] username:request.username password:request.password];
		} else {
			NSString *errorText = [request errorMessage];
			UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Could not login" message:errorText preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
								 { [av dismissViewControllerAnimated:YES completion:nil]; }];
			[av addAction: ok];
		}

		self.sessionId = nil;
		NSLog(@"logged in error unset empire");
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
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Could not relogin" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		
		self.sessionId = nil;
		NSLog(@"relogged in error unset empire");
		self.empire = nil;
		self.isLoggedIn = NO;
	} else {
		self.sessionId = request.sessionId;
		NSLog(@"relogin set empire");
		self.empire = [[[Empire alloc] init] autorelease];
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


#pragma mark - Class Methods

+ (Session *)sharedInstance {
    static dispatch_once_t pred;
    static Session *session = nil;
    
    dispatch_once(&pred, ^{ session = [[self alloc] init]; });
    return session;
}

@end

/*
 
 File: KeychainItemWrapper.m
 
 Abstract: Objective-C wrapper for accessing a single keychain item.
 
 Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by 
 Apple Inc. ("Apple") in consideration of your agreement to the
 following terms, and your use, installation, modification or
 redistribution of this Apple software constitutes acceptance of these
 terms.  If you do not agree with these terms, please do not use,
 install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. 
 may be used to endorse or promote products derived from the Apple
 Software without specific prior written permission from Apple.  Except
 as expressly stated in this notice, no other rights or licenses, express
 or implied, are granted by Apple herein, including but not limited to
 any patent rights that may be infringed by your derivative works or by
 other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008-2009 Apple Inc. All Rights Reserved.
 
 */ 

#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "LEMacros.h"
#import "Session.h"


#define LE_SEC_ITEM_ID @"LE_SEC_ITEM"


/*
 
 These are the default constants and their respective types,
 available for the kSecClassGenericPassword Keychain Item class:
 
 kSecAttrAccessGroup         -       CFStringRef
 kSecAttrCreationDate        -       CFDateRef
 kSecAttrModificationDate    -       CFDateRef
 kSecAttrDescription         -       CFStringRef
 kSecAttrComment             -       CFStringRef
 kSecAttrCreator             -       CFNumberRef
 kSecAttrType                -       CFNumberRef
 kSecAttrLabel               -       CFStringRef
 kSecAttrIsInvisible         -       CFBooleanRef
 kSecAttrIsNegative          -       CFBooleanRef
 kSecAttrAccount             -       CFStringRef
 kSecAttrService             -       CFStringRef
 kSecAttrGeneric             -       CFDataRef
 
 See the header file Security/SecItem.h for more details.
 
 */

@interface KeychainItemWrapper (PrivateMethods)
/*
 The decision behind the following two methods (secItemFormatToDictionary and dictionaryToSecItemFormat) was
 to encapsulate the transition between what the detail view controller was expecting (NSString *) and what the
 Keychain API expects as a validly constructed container class.
 */
+ (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
+ (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// Updates the item in the keychain, or adds it if it doesn't exist.
- (void)writeToKeychain;

@end

@implementation KeychainItemWrapper

@synthesize keychainItemData;
@synthesize	genericPasswordQuery;


#if TARGET_IPHONE_SIMULATOR
// Dummy implementations for no-building simulator target (reduce compiler warnings)
- (id)initWithUsername:(NSString *)username serverUri:(NSString *)serverUri accessGroup:(NSString *) accessGroup {
    if ((self = [super init])) {
		self.keychainItemData = [NSMutableDictionary dictionaryWithCapacity:1];
		[self.keychainItemData setObject:username forKey:(id)kSecAttrAccount];
		[self.keychainItemData setObject:serverUri forKey:(id)kSecAttrService];
	}
	
	return self;
}


- (void)setObject:(id)inObject forKey:(id)key {
	//Does nothing
}


- (id)objectForKey:(id)key {
	if (key == (id)kSecAttrAccount) {
		return [self.keychainItemData objectForKey:(id)kSecAttrAccount];
	} else if (key == (id)kSecValueData) {
		return @"abc123";
	} else if (key == (id)kSecAttrService) {
		return [self.keychainItemData objectForKey:(id)kSecAttrService];
	} else {
		return nil;
	}
}


- (void)resetKeychainItem {
	//Does nothing
}


- (void)dealloc {
    self.keychainItemData = nil;
    self.genericPasswordQuery = nil;
    
    [super dealloc];
}


+ (void)cleanUp {
}


#else


- (id)initWithUsername:(NSString *)username serverUri:(NSString *)serverUri accessGroup:(NSString *) accessGroup {
    if ((self = [super init])) {
        // Begin Keychain search setup. The genericPasswordQuery leverages the special user
        // defined attribute kSecAttrGeneric to distinguish itself between other generic Keychain
        // items which may be included by the same application.
        self.genericPasswordQuery = [[[NSMutableDictionary alloc] init] autorelease];
        
        [self.genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [self.genericPasswordQuery setObject:LE_SEC_ITEM_ID forKey:(id)kSecAttrGeneric];
        [self.genericPasswordQuery setObject:username forKey:(id)kSecAttrAccount];
        [self.genericPasswordQuery setObject:serverUri forKey:(id)kSecAttrService];
        
        // The keychain access group attribute determines if this item can be shared
        // amongst multiple apps whose code signing entitlements contain the same keychain access group.
        if (accessGroup != nil) {
            [self.genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
        }
        
        // Use the proper search constants, return only the attributes of the first match.
        [self.genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [self.genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];

		//UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"SAN Check" message:[NSString stringWithFormat:@"genericPasswordQuery: %@", self.genericPasswordQuery] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		//[av show];
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:self.genericPasswordQuery];
		
//		NSLog(@"genericPasswordQuery: %@", genericPasswordQuery);
//		NSLog(@"tempQuery: %@", tempQuery);
        
        NSMutableDictionary *outDictionary = nil;
        
		OSStatus copyResult = SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary);
//		NSLog(@"outDict: %@", outDictionary);
        if (copyResult == noErr) {
            // load the saved data from Keychain.
            self.keychainItemData = [KeychainItemWrapper secItemFormatToDictionary:outDictionary];
		} else if (copyResult == errSecItemNotFound) {
//			NSLog(@"NOT SET SO RESETTING");
			[self resetKeychainItem];
		} else {
//            // Stick these default values into keychain item if nothing found.
//            [self resetKeychainItem];
//            
//            // Add the generic attribute and the keychain access group.
//            [self.keychainItemData setObject:username forKey:(id)kSecAttrGeneric];
//            [self.keychainItemData setObject:serverUri forKey:(id)kSecAttrService];
//			
//            if (accessGroup != nil) {
//                [self.keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
//            }
			NSLog(@"UNKNOWN KEYCHAIN LOOK UP ERROR: %ld", copyResult);
			[self resetKeychainItem];
        }
		
        [outDictionary release];
    }
    
    return self;
}

- (void)dealloc
{
    self.keychainItemData = nil;
    self.genericPasswordQuery = nil;
    
    [super dealloc];
}

- (void)setObject:(id)inObject forKey:(id)key 
{
    if (inObject == nil) return;
    id currentObject = [self.keychainItemData objectForKey:key];
    if (![currentObject isEqual:inObject])
    {
        [self.keychainItemData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key
{
    return [self.keychainItemData objectForKey:key];
}

- (void)resetKeychainItem
{
    if (!self.keychainItemData) 
    {
        self.keychainItemData = [[[NSMutableDictionary alloc] init] autorelease];
    }
    else if (self.keychainItemData)
    {
        NSMutableDictionary *tempDictionary = [KeychainItemWrapper dictionaryToSecItemFormat:self.keychainItemData];
        SecItemDelete((CFDictionaryRef)tempDictionary);
    }
    
    // Default attributes for keychain item.
    [self.keychainItemData setObject:[self.genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
    [self.keychainItemData setObject:[self.genericPasswordQuery objectForKey:(id)kSecAttrGeneric] forKey:(id)kSecAttrGeneric];
    [self.keychainItemData setObject:[self.genericPasswordQuery objectForKey:(id)kSecAttrAccount] forKey:(id)kSecAttrAccount];
    [self.keychainItemData setObject:[self.genericPasswordQuery objectForKey:(id)kSecAttrService] forKey:(id)kSecAttrService];
    
    // Default data for keychain item.
    [self.keychainItemData setObject:@"" forKey:(id)kSecValueData];
}

+ (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for a SecItem.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the Generic Password keychain item class attribute.
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Convert the NSString to NSData to meet the requirements for the value type kSecValueData.
    // This is where to store sensitive data that should be encrypted.
    NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return returnDictionary;
}

+ (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for the UI element.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Acquire the password data from the attributes.
    NSData *passwordData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordData) == noErr)
    {
        // Remove the search, class, and identifier key/value, we don't need them anymore.
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        // Add the password to the dictionary, converting from NSData to NSString.
        NSString *password = [[[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] 
                                                     encoding:NSUTF8StringEncoding] autorelease];
        [returnDictionary setObject:password forKey:(id)kSecValueData];
    }
    else
    {
        // Don't do anything if nothing is found.
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
    
    [passwordData release];
	
    return returnDictionary;
}

- (void)writeToKeychain
{
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
    
	//UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"SAN Check" message:[NSString stringWithFormat:@"genericPasswordQuery: %@", self.genericPasswordQuery] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	//[av show];
	OSStatus copyResult = SecItemCopyMatching((CFDictionaryRef)self.genericPasswordQuery, (CFTypeRef *)&attributes);
//	NSLog(@"Attributes: %@", attributes);
    if (copyResult == noErr)
    {
//		NSLog(@"UPDATING");
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[self.genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [KeychainItemWrapper dictionaryToSecItemFormat:self.keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
        
        // An implicit assumption is that you can only update a single item at a time.
		OSStatus updateResult = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
        //NSAssert(updateResult == noErr, @"Couldn't update the Keychain Item." );

		if (updateResult != noErr) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Update" message:[NSString stringWithFormat:@"Result: %ld", updateResult] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
    } else {
//		NSLog(@"INSERTING");
		OSStatus addResult = SecItemAdd((CFDictionaryRef)[KeychainItemWrapper dictionaryToSecItemFormat:self.keychainItemData], NULL);
        //NSAssert(addResult == noErr, @"Couldn't add the Keychain Item.");

		if (addResult != noErr) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Add" message:[NSString stringWithFormat:@"Result: %ld", addResult] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
    }
}


#pragma mark -
#pragma mark Class Methods

+ (void)cleanUp {
//	NSLog(@"cleanUp Called");
	//Get stored accounts
	Session *session = [Session sharedInstance];
	NSMutableDictionary *savedEmpires = [NSMutableDictionary dictionaryWithCapacity:[session.savedEmpireList count]];
	for (NSDictionary *empire in session.savedEmpireList) {
		[savedEmpires setObject:empire forKey:[NSString stringWithFormat:@"%@-%@", [empire objectForKey:@"username"], [empire objectForKey:@"uri"]]];
	}
	
	//Get Saved Sec Items
	NSMutableDictionary *passwordQuery;
	passwordQuery = [[NSMutableDictionary alloc] init];
	[passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[passwordQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	NSDictionary *tempPasswordQuery = [NSDictionary dictionaryWithDictionary:passwordQuery];
	NSMutableArray *outArray = nil;
	NSMutableArray *goodSecItems = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray *partialSecItems = [NSMutableArray arrayWithCapacity:10];
	SecItemCopyMatching((CFDictionaryRef)tempPasswordQuery, (CFTypeRef *)&outArray);
	for (NSMutableDictionary *outDictionary in outArray) {
		NSMutableDictionary *passwordDict = [self secItemFormatToDictionary:outDictionary];
		NSString *itemId = [passwordDict objectForKey:(id)kSecAttrGeneric];

		//Split Sec Items into Good (all 3 account parts) and Partial
		NSString *username = [passwordDict objectForKey:(id)kSecAttrAccount];
		NSString *service = [passwordDict objectForKey:(id)kSecAttrService];
		NSString *password = [passwordDict objectForKey:(id)kSecValueData]; 
		if (isNotEmptyString(itemId) && isNotEmptyString(username) && isNotEmptyString(service) && isNotEmptyString(password)) {
			[goodSecItems addObject:passwordDict];
		} else {
			[partialSecItems addObject:passwordDict];
		}
	}
	
	//Process Good Sec Items
	for (NSDictionary *secItem in goodSecItems) {
//		NSLog(@"Processing good secItem: %@", secItem);
		NSString *itemId = [secItem objectForKey:(id)kSecAttrGeneric];
		NSString *username = [secItem objectForKey:(id)kSecAttrAccount];
		NSString *service = [secItem objectForKey:(id)kSecAttrService];
		NSString *password = [secItem objectForKey:(id)kSecValueData]; 
		NSString *empireKey = [NSString stringWithFormat:@"%@-%@", username, service];
		NSDictionary *empire = [savedEmpires objectForKey:empireKey];
		//If does not have matching stored empire then delete sec item
		if (!empire) {
//			NSLog(@"Delete this item");
			SecItemDelete((CFDictionaryRef)[KeychainItemWrapper dictionaryToSecItemFormat:secItem]);
		}
		if (![itemId isEqualToString:LE_SEC_ITEM_ID]) {
//			NSLog(@"Creating new item");
			//Delete this Item
			SecItemDelete((CFDictionaryRef)[KeychainItemWrapper dictionaryToSecItemFormat:secItem]);
			//Create Real SEC ITEM
			KeychainItemWrapper *tmp = [[KeychainItemWrapper alloc] initWithUsername:username serverUri:service accessGroup:nil];
			[tmp setObject:password forKey:(id)kSecValueData];
			[tmp release];
		}
		[savedEmpires removeObjectForKey:empireKey];
	}
	
	//Process Partial Sec Items
	for (NSDictionary *secItem in partialSecItems) {
//		NSLog(@"Processing partial secItem: %@", secItem);
		NSString *username = [secItem objectForKey:(id)kSecAttrAccount];
		NSString *service = [secItem objectForKey:(id)kSecAttrService];
		NSString *password = [secItem objectForKey:(id)kSecValueData]; 
		if ([username isEqualToString:@"bob3"]) {
			service = @"https://pt.lacunaexpanse.com/";
		}
		NSString *empireKey = [NSString stringWithFormat:@"%@-%@", username, service];
		NSDictionary *empire = [savedEmpires objectForKey:empireKey];
		//If does not have matching stored empire then delete sec item
		if (!empire) {
//			NSLog(@"Delete this item");
			SecItemDelete((CFDictionaryRef)[KeychainItemWrapper dictionaryToSecItemFormat:secItem]);
		} else {
//			NSLog(@"Creating new item");
			//Delete this Item
			SecItemDelete((CFDictionaryRef)[KeychainItemWrapper dictionaryToSecItemFormat:secItem]);
			//Create Real SEC ITEM
			KeychainItemWrapper *tmp = [[KeychainItemWrapper alloc] initWithUsername:username serverUri:service accessGroup:nil];
			[tmp setObject:password forKey:(id)kSecValueData];
			[tmp release];
		}

		[savedEmpires removeObjectForKey:empireKey];
	}
	
	[passwordQuery release];
}


#endif

@end
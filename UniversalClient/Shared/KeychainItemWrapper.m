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
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// Updates the item in the keychain, or adds it if it doesn't exist.
- (void)writeToKeychain;

@end

@implementation KeychainItemWrapper

@synthesize keychainItemData;
@synthesize	genericPasswordQuery;


#if TARGET_IPHONE_SIMULATOR
// Dummy implementations for no-building simulator target (reduce compiler warnings)
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup {
    if (self = [super init]) {
		self.keychainItemData = [NSMutableDictionary dictionaryWithCapacity:1];
		[self.keychainItemData setObject:identifier forKey:(id)kSecAttrAccount];
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
		return @"https://pt.lacunaexpanse.com/";
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


#else


- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup {
    if (self = [super init]) {
        // Begin Keychain search setup. The genericPasswordQuery leverages the special user
        // defined attribute kSecAttrGeneric to distinguish itself between other generic Keychain
        // items which may be included by the same application.
        self.genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
        [self.genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [self.genericPasswordQuery setObject:identifier forKey:(id)kSecAttrGeneric];
        
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
        
        NSMutableDictionary *outDictionary = nil;
        
		OSStatus copyResult = SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary);
        if (! copyResult == noErr) {
            // Stick these default values into keychain item if nothing found.
            [self resetKeychainItem];
            
            // Add the generic attribute and the keychain access group.
            [self.keychainItemData setObject:identifier forKey:(id)kSecAttrGeneric];
            if (accessGroup != nil) {
                [self.keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
            }
        } else {
            // load the saved data from Keychain.
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
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
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:self.keychainItemData];
        SecItemDelete((CFDictionaryRef)tempDictionary);
    }
    
    // Default attributes for keychain item.
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrAccount];
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrLabel];
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrDescription];
    
    // Default data for keychain item.
    [self.keychainItemData setObject:@"" forKey:(id)kSecValueData];
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
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

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
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
    if (copyResult == noErr)
    {
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[self.genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:self.keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
        
        // An implicit assumption is that you can only update a single item at a time.
		OSStatus updateResult = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
        //NSAssert(updateResult == noErr, @"Couldn't update the Keychain Item." );

		if (updateResult != noErr) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Update" message:[NSString stringWithFormat:@"Result: %d", updateResult] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
    }
    else
    {
		OSStatus addResult = SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:self.keychainItemData], NULL);
        NSAssert(addResult == noErr, @"Couldn't add the Keychain Item.");

		if (addResult != noErr) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Add" message:[NSString stringWithFormat:@"Result: %d", addResult] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
    }
}

#endif

@end
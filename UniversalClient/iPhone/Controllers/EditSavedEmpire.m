//
//  EditSavedEmpire.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditSavedEmpire.h"
#import "KeychainItemWrapper.h"
#import "Session.h"


@implementation EditSavedEmpire


@synthesize username;
@synthesize password;
@synthesize server;
@synthesize empireName;


#pragma mark --
#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Edit Account Info";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];

	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:self.empireName accessGroup:nil] autorelease];
	self.username.text = [keychainItemWrapper objectForKey:(id)kSecAttrAccount];
	self.password.text = [keychainItemWrapper objectForKey:(id)kSecValueData];
	self.server.text = [keychainItemWrapper objectForKey:(id)kSecAttrService];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.username = nil;
	self.password = nil;
	self.server = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.empireName = nil;
    [super dealloc];
}


#pragma mark --
#pragma mark View Methods

- (IBAction)cancel {
	NSLog(@"Cancel Called");
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)save {
	NSLog(@"Save Called");
	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:self.empireName accessGroup:nil] autorelease];
	[keychainItemWrapper setObject:self.username.text forKey:(id)kSecAttrAccount];
	[keychainItemWrapper setObject:self.password.text forKey:(id)kSecValueData];
	[keychainItemWrapper setObject:self.server.text forKey:(id)kSecAttrService];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)login {
	NSLog(@"Load Called");
	
	Session *session = [Session sharedInstance];
	[session loginWithUsername:self.username.text password:self.password.text];
	
	[self.navigationController popViewControllerAnimated:YES];
}


@end

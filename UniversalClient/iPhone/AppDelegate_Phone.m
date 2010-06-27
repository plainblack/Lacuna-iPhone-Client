//
//  AppDelegate_Phone.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright n/a 2010. All rights reserved.
//

#import "AppDelegate_Phone.h"
#import "Session.h"
#import	"LEMacros.h"
#import "ViewBodyController.h"
#import "ViewMailboxController.h"

@implementation AppDelegate_Phone


@synthesize tabBarController;
@synthesize mailTabBarItem;
@synthesize myWorldsNavigationController;
@synthesize myWorldController;
@synthesize mailNavigationController;
@synthesize mailboxController;


#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[application setStatusBarHidden:NO withAnimation:YES];

	Session *session = [Session sharedInstance];
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

	return YES;
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	Session *session = [Session sharedInstance];
	[session removeObserver:self forKeyPath:@"numNewMessages"];

	self.tabBarController = nil;
	self.mailTabBarItem = nil;
	self.myWorldsNavigationController = nil;
	self.myWorldController = nil;
	self.mailNavigationController = nil;
	self.mailboxController = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark KVO Methods


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	if ([viewController.tabBarItem.title isEqualToString:@"Empire"]) {
		return YES;
	} else {
		Session *session = [Session sharedInstance];
		return session.isLoggedIn;
	}
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"numNewMessages"]) {
		Empire *empire = (Empire *)object;
		if (empire) {
			if(empire.numNewMessages > 0) {
				self.mailTabBarItem.badgeValue = [NSString stringWithFormat:@"%i", empire.numNewMessages];
			} else {
				self.mailTabBarItem.badgeValue = nil;
			}
		}
	} else if ( [keyPath isEqual:@"isLoggedIn"]) {
		Session *session = (Session *)object;
		if (!session.isLoggedIn) {
			[self.myWorldsNavigationController popToRootViewControllerAnimated:NO];
			[self.myWorldController clear];
			[self.mailNavigationController popToRootViewControllerAnimated:NO];
			[self.mailboxController clear];
		} else {
			if(session.empire.numNewMessages > 0) {
				self.mailTabBarItem.badgeValue = [NSString stringWithFormat:@"%i", session.empire.numNewMessages];
			} else {
				self.mailTabBarItem.badgeValue = nil;
			}
			[session.empire addObserver:self forKeyPath:@"numNewMessages" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		}
	}
}


@end


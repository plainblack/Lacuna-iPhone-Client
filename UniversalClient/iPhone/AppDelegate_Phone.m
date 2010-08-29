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
#import "LERequest.h"
#import "LoginController.h"


@interface AppDelegate_Phone(PrivateMethod)

- (void)displayLogin;
- (void)hideLogin;

@end


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
	
	for (UIViewController *viewController in self.tabBarController.viewControllers) {
		if ([viewController isKindOfClass:[UINavigationController class]]) {
			((UINavigationController *)viewController).navigationBar.tintColor = TINT_COLOR;
		}
	}
	
	[window addSubview:self.tabBarController.view];
    [window makeKeyAndVisible];

	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[application setStatusBarHidden:NO withAnimation:YES];

	Session *session = [Session sharedInstance];
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidBecomeActive:application];
	Session *session = [Session sharedInstance];
	if (!session.isLoggedIn) {
		[self displayLogin];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidBecomeActive:application];
	NSLog(@"Will resign active");
	if ([LERequest getCurrentRequestCount] > 0) {
		NSLog(@"Active requests!");
		[LERequest setDelegate:self];
		self->backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
			NSLog(@"WTF should this do?");
		}];
	} else {
		NSLog(@"No active requests");
	}

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidEnterBackground:application];
	NSLog(@"Entered background");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationWillEnterForeground:application];
	NSLog(@"Will enter foreground");
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidFinishLaunching:application];
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
			if(_intv(empire.numNewMessages) > 0) {
				self.mailTabBarItem.badgeValue = [NSString stringWithFormat:@"%@", empire.numNewMessages];
			} else {
				self.mailTabBarItem.badgeValue = nil;
			}
		}
	} else if ( [keyPath isEqual:@"isLoggedIn"]) {
		Session *session = (Session *)object;
		[change objectForKey:NSKeyValueChangeNewKey];
		if (session.isLoggedIn) {
			if(_intv(session.empire.numNewMessages) > 0) {
				self.mailTabBarItem.badgeValue = [NSString stringWithFormat:@"%@", session.empire.numNewMessages];
			} else {
				self.mailTabBarItem.badgeValue = nil;
			}
			[session.empire addObserver:self forKeyPath:@"numNewMessages" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			[self hideLogin];
		} else {
			[self.myWorldsNavigationController popToRootViewControllerAnimated:NO];
			[self.myWorldController clear];
			[self.mailNavigationController popToRootViewControllerAnimated:NO];
			[self.mailboxController clear];
			self.mailTabBarItem.badgeValue = nil;
			[session.empire removeObserver:self forKeyPath:@"numNewMessages"];
			[self displayLogin];
		}
	}
}


#pragma mark --
#pragma mark LERequestMonitor Methods

- (void)allRequestsComplete {
	NSLog(@"ALL REQUESTS COMPLETE");
	[LERequest setDelegate:nil];
	[[UIApplication sharedApplication] endBackgroundTask:self->backgroundTask];
}


#pragma mark --
#pragma mark PrivateMethod

- (void)displayLogin {
	LoginController *loginController = [LoginController create];
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:loginController] autorelease];
	navController.navigationBar.tintColor = TINT_COLOR;
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.tabBarController presentModalViewController:navController animated:YES];
}


- (void)hideLogin {
	[self.tabBarController dismissModalViewControllerAnimated:YES];
}


@end


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
#import "Reachability.h"


@interface AppDelegate_Phone(PrivateMethod)

- (void)displayLoginAnimated:(BOOL)animated;
- (void)hideLogin;
- (void)testReachability:(Reachability *)reachability;

@end


@implementation AppDelegate_Phone


@synthesize tabBarController;
@synthesize mailTabBarItem;
@synthesize myWorldsNavigationController;
@synthesize myWorldController;
@synthesize mailNavigationController;
@synthesize mailboxController;
@synthesize internetReachability;
@synthesize notConnectedView;


#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	for (UIViewController *viewController in self.tabBarController.viewControllers) {
		if ([viewController isKindOfClass:[UINavigationController class]]) {
			((UINavigationController *)viewController).navigationBar.tintColor = TINT_COLOR;
		}
	}
	self.tabBarController.moreNavigationController.navigationBar.tintColor = TINT_COLOR;
	
	[window addSubview:self.tabBarController.view];
    [window makeKeyAndVisible];

	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[application setStatusBarHidden:NO withAnimation:YES];
	
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

	self.internetReachability = [Reachability reachabilityForInternetConnection];

	Session *session = [Session sharedInstance];
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session addObserver:self forKeyPath:@"lacunanMessageId" options:(NSKeyValueObservingOptionNew) context:NULL];
	
	return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidBecomeActive:application];

	[self.internetReachability startNotifier];
	[self testReachability:self.internetReachability];

	Session *session = [Session sharedInstance];
	if (!session.isLoggedIn) {
		[self displayLoginAnimated:NO];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidBecomeActive:application];
	[self.internetReachability stopNotifier];

	if ([LERequest getCurrentRequestCount] > 0) {
		[LERequest setDelegate:self];
		self->backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
		}];
	}

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	//IS NO SUPER METHOD SO DON'T CALL IT!
	//[super applicationWillEnterForeground:application];
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
	self.internetReachability = nil;
	self.notConnectedView = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)showMessage:(NSString *)messageId {
	self.tabBarController.selectedViewController = self.mailNavigationController;
	[self.mailboxController showMessageById:messageId];
}


#pragma mark -
#pragma mark TabBarController Delegate Methods


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
	Session *session = (Session *)object;
	if ( [keyPath isEqualToString:@"numNewMessages"]) {
		Empire *empire = (Empire *)object;
		if (empire) {
			if(_intv(empire.numNewMessages) > 0) {
				self.mailTabBarItem.badgeValue = [NSString stringWithFormat:@"%@", empire.numNewMessages];
			} else {
				self.mailTabBarItem.badgeValue = nil;
			}
		}
	} else if ( [keyPath isEqualToString:@"isLoggedIn"]) {
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
			[self displayLoginAnimated:YES];
		}
	} else if ([keyPath isEqualToString:@"lacunanMessageId"]) {
		if (session.lacunanMessageId) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Welcome to Lacuna Expanse. The Lacunan's have a message for you. Shall I taked you to your Inbox to view it?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] autorelease];
			[av show];
		}
	}

}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(int)index {
	Session *session = [Session sharedInstance];
	if (index != [alertView cancelButtonIndex]) {
		if (session.lacunanMessageId) {
			[self showMessage:session.lacunanMessageId];
		}
	}
}


#pragma mark -
#pragma mark LERequestMonitor Methods

- (void)allRequestsComplete {
	NSLog(@"ALL REQUESTS COMPLETE");
	[LERequest setDelegate:nil];
	[[UIApplication sharedApplication] endBackgroundTask:self->backgroundTask];
}


#pragma mark -
#pragma mark Callback methods

- (void) reachabilityChanged:(NSNotification* )note {
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self testReachability:curReach];
}


#pragma mark -
#pragma mark PrivateMethod

- (void)displayLoginAnimated:(BOOL)animated {
	LoginController *loginController = [LoginController create];
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:loginController] autorelease];
	navController.navigationBar.tintColor = TINT_COLOR;
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.tabBarController presentModalViewController:navController animated:animated];
}


- (void)hideLogin {
	self.tabBarController.selectedViewController = self.myWorldsNavigationController;
	[self.tabBarController dismissModalViewControllerAnimated:YES];
}


- (void)testReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
	NSString *statusString;
	switch (netStatus) {
        case NotReachable:
            statusString = @"Access Not Available";
            break;
        case ReachableViaWWAN:
            statusString = @"Reachable WWAN";
            break;
        case ReachableViaWiFi:
			statusString = @"Reachable WiFi";
            break;
    }
	
	if (netStatus == NotReachable) {
		if (!self.notConnectedView.superview) {
			[window addSubview:self.notConnectedView];
		}

	} else {
		if (self.notConnectedView.superview) {
			[self.notConnectedView removeFromSuperview];
		}
	}
}


@end


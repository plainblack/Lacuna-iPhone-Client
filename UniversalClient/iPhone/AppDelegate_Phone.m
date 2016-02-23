//
//  AppDelegate_Phone.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright n/a 2010. All rights reserved.
//

#import "AppDelegate_Phone.h"
#import	"LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "ViewBodyController.h"
#import "ViewMailboxController.h"
#import "LERequest.h"
#import "LoginController.h"
#import "Reachability.h"
#import "ViewUniverseController.h"
#import "SelectSpeciesTemplateController.h"
#import "WebPageController.h"
#import "ViewTipsController.h"
//#import "ChatController.h"
#import "CaptchaViewController.h"


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
@synthesize viewUniverseController;
@synthesize viewUniverseNavigationController;
@synthesize viewTipsController;
//@synthesize ChatController;
//@synthesize chatNavigationController;

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

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *initialViewControllers = [NSArray arrayWithArray:self.tabBarController.viewControllers];
    NSArray *tabBarOrder = [userDefaults objectForKey:@"tabBarOrder"];
    if (tabBarOrder) {
        NSMutableArray *newViewControllers = [NSMutableArray arrayWithCapacity:initialViewControllers.count];
        for (NSNumber *tabBarNumber in tabBarOrder) {
            NSUInteger tabBarIndex = [tabBarNumber unsignedIntegerValue];
            [newViewControllers addObject:[initialViewControllers objectAtIndex:tabBarIndex]];
        }
		for (NSInteger idx = [tabBarOrder count]; idx < [initialViewControllers count]; idx++) {
            [newViewControllers addObject:[initialViewControllers objectAtIndex:idx]];
		}
        self.tabBarController.viewControllers = newViewControllers;
    }
	
	//[self.window addSubview:self.tabBarController.view];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[application setStatusBarHidden:NO withAnimation:YES];
	
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

	self.internetReachability = [Reachability reachabilityForInternetConnection];

	Session *session = [Session sharedInstance];
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
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
	[session.empire removeObserver:self forKeyPath:@"numNewMessages"];

	self.tabBarController = nil;
	self.mailTabBarItem = nil;
	self.myWorldsNavigationController = nil;
	self.myWorldController = nil;
	self.mailNavigationController = nil;
	self.mailboxController = nil;
	self.internetReachability = nil;
	self.notConnectedView = nil;
	self.viewUniverseController = nil;
	self.viewUniverseNavigationController = nil;
	self.viewTipsController = nil;
//    self.ChatController = nil;
//    chatNavigationController
	
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)showMessage:(NSString *)messageId {
	self.tabBarController.selectedViewController = self.mailNavigationController;
	[self.mailboxController showMessageById:messageId];
}


- (void)showMyWorld:(NSString *)bodyId {
	self.myWorldController.bodyId = bodyId;
	self.tabBarController.selectedViewController = self.myWorldsNavigationController;
}


- (void)showStarMapGridX:(NSDecimalNumber *)x gridY:(NSDecimalNumber *)y {
	self.viewUniverseController.gotoGridX = x;
	self.viewUniverseController.gotoGridY = y;
	self.tabBarController.selectedViewController = self.viewUniverseNavigationController;
}


- (void)setStarMapGridX:(NSDecimalNumber *)x gridY:(NSDecimalNumber *)y {
	self.viewUniverseController.gotoGridX = x;
	self.viewUniverseController.gotoGridY = y;
}


- (void)showTips {
	self.tabBarController.selectedViewController = self.viewTipsController;
}

//- (void)showChat:(NSString *)messageId {
//	self.tabBarController.selectedViewController = self.mailNavigationController;
//}

- (void)restartCreateEmpireId:(NSString *)empireId username:(NSString *)username password:(NSString *)password {
	NSLog(@"Need to restart create for %@", empireId);
	SelectSpeciesTemplateController *selectNewEmpireSpeciesController = [SelectSpeciesTemplateController create];
	selectNewEmpireSpeciesController.empireId = empireId;
	selectNewEmpireSpeciesController.username = username;
	selectNewEmpireSpeciesController.password = password;
	[((UINavigationController *)[self.tabBarController modalViewController]) pushViewController:selectNewEmpireSpeciesController animated:YES];
}


- (void)showAnnouncement {
	Session *session = [Session sharedInstance];
	NSURL *baseUrl = [NSURL URLWithString:session.serverUri];
	NSURL *announcementUrl = [NSURL URLWithString:[NSString stringWithFormat:@"/announcement?session_id=%@", session.sessionId] relativeToURL:baseUrl];
	WebPageController *webPageController = [WebPageController create];
	[webPageController goToUrl:[announcementUrl absoluteString]];
	[self.tabBarController presentViewController:webPageController animated:YES completion:nil];
}


- (void)gameover:(NSString *)endGameUrl {
	WebPageController *webPageController = [WebPageController create];
	[webPageController goToUrl:endGameUrl];
	if (self.tabBarController.presentedViewController) {
		[self.tabBarController.presentedViewController presentViewController:webPageController animated:YES completion:nil];
	} else {
		[self.tabBarController presentViewController:webPageController animated:YES completion:nil];
	}
}


- (void)captchaValidate:(LERequest *)requestToValidate {
	CaptchaViewController *captchaViewController = [CaptchaViewController create];
	captchaViewController.requestNeedingCaptcha = requestToValidate;
	[self.tabBarController presentViewController:captchaViewController animated:YES completion:nil];
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


- (void)tabBarController:(UITabBarController *)inTabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	NSUInteger count = inTabBarController.viewControllers.count;
	NSMutableArray *tabOrderArray = [[NSMutableArray alloc] initWithCapacity:count];
	for (UIViewController *viewController in viewControllers) {
		NSInteger tag = viewController.tabBarItem.tag;
		[tabOrderArray addObject:[NSNumber numberWithInteger:tag]];
	}
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[NSArray arrayWithArray:tabOrderArray] forKey:@"tabBarOrder"];
	[userDefaults synchronize];
	[tabOrderArray release];
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
			if (session.lacunanMessageId) {
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Welcome to Lacuna Expanse. The Lacunan's have a message for you. Shall I taked you to your Inbox to view it?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] autorelease];
				[av show];
			} else {
				NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
				BOOL hideTipsAlert = [userDefaults boolForKey:@"HideTipsAlert"];
				if (!hideTipsAlert) {
					UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"View tips?" message:@"Welcome back! Would you like to view tips and hints?" delegate:self cancelButtonTitle:@"No and don't ask again" otherButtonTitles:@"Yes", @"No", nil] autorelease];
					[av show];
				}
			}

		} else {
			[self.myWorldsNavigationController popToRootViewControllerAnimated:NO];
			[self.myWorldController clear];
			[self.viewUniverseController clear];
			[self.mailNavigationController popToRootViewControllerAnimated:NO];
			[self.mailboxController clear];
			self.mailTabBarItem.badgeValue = nil;
			[session.empire removeObserver:self forKeyPath:@"numNewMessages"];
			[self displayLoginAnimated:YES];
		}
	}

}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(long)index {
	Session *session = [Session sharedInstance];
	if ([alertView.title isEqualToString:@"Welcome"]) {
		if (index != [alertView cancelButtonIndex]) {
			if (session.lacunanMessageId) {
				[self showMessage:session.lacunanMessageId];
			}
		}
	} else {
		if (index == [alertView cancelButtonIndex]) {
			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
			[userDefaults setBool:YES forKey:@"HideTipsAlert"];
		} else {
			NSLog(@"Index: %li", index);
			if (index == 1) {
				[self showTips];
			}
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
	[self.tabBarController presentViewController:navController animated:animated completion:nil];
}


- (void)hideLogin {
	self.tabBarController.selectedViewController = self.myWorldsNavigationController;
	[self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


- (void)testReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
	if (netStatus == NotReachable) {
		if (!self.notConnectedView.superview) {
			[self.window addSubview:self.notConnectedView];
		}

	} else {
		if (self.notConnectedView.superview) {
			[self.notConnectedView removeFromSuperview];
		}
	}
}


@end


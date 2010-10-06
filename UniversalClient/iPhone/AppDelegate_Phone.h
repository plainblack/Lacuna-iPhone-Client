//
//  AppDelegate_Phone.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright n/a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "LERequest.h"


@class Reachability;
@class ViewBodyController;
@class ViewMailboxController;
@class ViewUniverseController;


@interface AppDelegate_Phone : AppDelegate_Shared <UITabBarDelegate, LERequestMonitor, UIAlertViewDelegate> {
	UITabBarController *tabBarController;
	UITabBarItem *mailTabBarItem;
	UINavigationController *myWorldsNavigationController;
	ViewBodyController *myWorldController;
	UINavigationController *mailNavigationController;
	ViewMailboxController *mailboxController;
	UIBackgroundTaskIdentifier backgroundTask;
	Reachability *internetReachability;
	UIView *notConnectedView;
	ViewUniverseController *viewUniverseController;
	UINavigationController *viewUniverseNavigationController;
}


@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic, retain) IBOutlet UITabBarItem *mailTabBarItem;
@property(nonatomic, retain) IBOutlet UINavigationController *myWorldsNavigationController;
@property(nonatomic, retain) IBOutlet ViewBodyController *myWorldController;
@property(nonatomic, retain) IBOutlet UINavigationController *mailNavigationController;
@property(nonatomic, retain) IBOutlet ViewMailboxController *mailboxController;
@property(nonatomic, retain) Reachability *internetReachability;
@property(nonatomic, retain) IBOutlet UIView *notConnectedView;
@property(nonatomic, retain) IBOutlet ViewUniverseController *viewUniverseController;
@property(nonatomic, retain) IBOutlet UINavigationController *viewUniverseNavigationController;


- (void)showMessage:(NSString *)messageId;
- (void)showStarMapGridX:(NSDecimalNumber *)x gridY:(NSDecimalNumber *)y;
- (void)showMyWorld:(NSString *)bodyId;
- (void)restartCreateEmpireId:(NSString *)empireId username:(NSString *)username password:(NSString *)password;


@end


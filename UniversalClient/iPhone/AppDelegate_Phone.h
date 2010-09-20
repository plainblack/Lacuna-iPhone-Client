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


@class ViewBodyController;
@class ViewMailboxController;


@interface AppDelegate_Phone : AppDelegate_Shared <UITabBarDelegate, LERequestMonitor, UIAlertViewDelegate> {
	UITabBarController *tabBarController;
	UITabBarItem *mailTabBarItem;
	UINavigationController *myWorldsNavigationController;
	ViewBodyController *myWorldController;
	UINavigationController *mailNavigationController;
	ViewMailboxController *mailboxController;
	UIBackgroundTaskIdentifier backgroundTask;
}


@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic, retain) IBOutlet UITabBarItem *mailTabBarItem;
@property(nonatomic, retain) IBOutlet UINavigationController *myWorldsNavigationController;
@property(nonatomic, retain) IBOutlet ViewBodyController *myWorldController;
@property(nonatomic, retain) IBOutlet UINavigationController *mailNavigationController;
@property(nonatomic, retain) IBOutlet ViewMailboxController *mailboxController;


- (void)showMessage:(NSString *)messageId;


@end


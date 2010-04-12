//
//  AppDelegate_Phone.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright n/a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@interface AppDelegate_Phone : AppDelegate_Shared <UITabBarDelegate> {
	UITabBarController *tabBarController;
	UITabBarItem *mailTabBarItem;
}


@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic, retain) IBOutlet UITabBarItem *mailTabBarItem;


@end


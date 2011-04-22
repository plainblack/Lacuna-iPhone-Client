//
//  LEPullToRefreshTableViewControllerGrouped.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"


@interface LEPullToRefreshTableViewControllerGrouped : PullRefreshTableViewController {
}


@property (nonatomic, retain) NSArray *sectionHeaders;
@property (nonatomic, assign) BOOL pendingRequest;


@end

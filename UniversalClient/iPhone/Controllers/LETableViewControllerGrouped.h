//
//  LETableViewControllerGrouped.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewControllerGrouped : UITableViewController {
	NSArray *sectionHeaders;
	BOOL pendingRequest;
}


@property (nonatomic, retain) NSArray *sectionHeaders;
@property (nonatomic, assign) BOOL pendingRequest;


@end

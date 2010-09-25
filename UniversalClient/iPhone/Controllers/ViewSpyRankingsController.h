//
//  ViewSpyRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewSpyRankingsController : LETableViewControllerGrouped {
	NSString *sortBy;
	NSMutableArray *spies;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *spies;


+ (ViewSpyRankingsController *) create;


@end

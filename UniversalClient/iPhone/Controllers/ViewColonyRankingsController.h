//
//  ViewColonyRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewColonyRankingsController : LETableViewControllerGrouped {
	NSString *sortBy;
	NSMutableArray *colonies;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *colonies;


+ (ViewColonyRankingsController *) create;


@end

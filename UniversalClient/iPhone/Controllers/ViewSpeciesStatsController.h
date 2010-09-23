//
//  ViewRacialStatsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewSpeciesStatsController : LETableViewControllerGrouped {
	NSDictionary *racialStats;
}


@property (nonatomic, retain) NSDictionary *racialStats;


+ (ViewSpeciesStatsController *)create;


@end

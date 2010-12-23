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
}


@property (nonatomic, retain) NSMutableDictionary *racialStats;


+ (ViewSpeciesStatsController *)create;


@end

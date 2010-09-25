//
//  ViewWeeklyMedalWinnersController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewWeeklyMedalWinnersController : LETableViewControllerGrouped {
	NSMutableArray *winners;
}

@property (nonatomic, retain) NSMutableArray *winners;


+ (ViewWeeklyMedalWinnersController *) create;


@end

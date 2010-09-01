//
//  ViewCreditsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LEStatsCredits;


@interface ViewCreditsController : LETableViewControllerGrouped {
	LEStatsCredits *leStatsCredits;
}


@property (nonatomic, retain) LEStatsCredits *leStatsCredits;


- (IBAction)logout;


+ (ViewCreditsController *)create;


@end

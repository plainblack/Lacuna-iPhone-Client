//
//  ViewProbedStarsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Observatory;
@class Star;


@interface ViewProbedStarsController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	Observatory *observatory;
	Star *selectedStar;
}


@property (nonatomic, retain) Observatory *observatory;
@property (nonatomic, retain) Star *selectedStar;


+ (ViewProbedStarsController *)create;


@end

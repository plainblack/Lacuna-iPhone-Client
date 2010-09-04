//
//  ViewMedalsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellLabeledSwitch.h"


@interface ViewMedalsController : LETableViewControllerGrouped <LETableViewCellLabeledSwitchDelegate> {
	NSArray *medals;
}


@property (nonatomic, retain) NSArray *medals;


+ (ViewMedalsController *)create;


@end

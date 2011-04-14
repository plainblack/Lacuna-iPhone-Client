//
//  ProposeEvictMiningPlatformViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarInJurisdictionViewController.h"


@class Parliament;


@interface ProposeEvictMiningPlatformViewController : LETableViewControllerGrouped <SelectStarInJurisdictionViewControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedMiningPlatform;


- (void)propose;


+ (ProposeEvictMiningPlatformViewController *)create;


@end

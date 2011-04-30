//
//  SelectMiningPlatformForBodyInJurisdictionViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;


@protocol SelectMiningPlatformForBodyInJurisdictionViewControllerDelegate

- (void)selectedMiningPlatformForBodyInJurisdiction:(NSDictionary *)miningPlatform;

@end


@interface SelectMiningPlatformForBodyInJurisdictionViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *body;
@property (nonatomic, retain) NSMutableArray *miningPlatforms;
@property (nonatomic, assign) id<SelectMiningPlatformForBodyInJurisdictionViewControllerDelegate> delegate;


+ (SelectMiningPlatformForBodyInJurisdictionViewController *)create;


@end

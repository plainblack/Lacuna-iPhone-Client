//
//  SelectStarInJurisdictionViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;


@protocol SelectStarInJurisdictionViewControllerDelegate

- (void)selectedStarInJurisdiction:(NSDictionary *)star;

@end


@interface SelectStarInJurisdictionViewController : LETableViewControllerGrouped {
    BOOL watchingStarsInJurisdiction;
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, assign) id<SelectStarInJurisdictionViewControllerDelegate> delegate;


+ (SelectStarInJurisdictionViewController *)create;


@end

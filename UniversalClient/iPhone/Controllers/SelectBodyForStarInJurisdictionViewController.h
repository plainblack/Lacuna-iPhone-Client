//
//  SelectBodyForStarInJurisdictionViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;


@protocol SelectBodyForStarInJurisdictionViewControllerDelegate

- (void)selectedBodyForStarInJurisdiction:(NSDictionary *)body;

@end


@interface SelectBodyForStarInJurisdictionViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *star;
@property (nonatomic, retain) NSMutableArray *bodies;
@property (nonatomic, assign) BOOL asteroidsOnly;
@property (nonatomic, assign) id<SelectBodyForStarInJurisdictionViewControllerDelegate> delegate;


+ (SelectBodyForStarInJurisdictionViewController *)create;


@end

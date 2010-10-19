//
//  SelectShipFromListController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Ship;


@protocol SelectShipFromListControllerDelegate

- (void)shipSelected:(Ship *)ship;

@end


@interface SelectShipFromListController : LETableViewControllerGrouped {
}


@property (nonatomic, copy) NSMutableArray *ships;
@property (nonatomic, copy) NSMutableDictionary *shipTravelTimes;
@property (nonatomic, assign) id<SelectShipFromListControllerDelegate> delegate;


+ (SelectShipFromListController *) create;


@end

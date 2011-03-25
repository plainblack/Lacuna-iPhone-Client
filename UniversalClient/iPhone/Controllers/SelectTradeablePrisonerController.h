//
//  SelectTradeablePrisonerController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Prisoner;


@protocol SelectTradeablePrisonerControllerDelegate

- (void)prisonerSelected:(Prisoner *)prisoner;

@end


@interface SelectTradeablePrisonerController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectTradeablePrisonerControllerDelegate> delegate;


+ (SelectTradeablePrisonerController *) create;


@end

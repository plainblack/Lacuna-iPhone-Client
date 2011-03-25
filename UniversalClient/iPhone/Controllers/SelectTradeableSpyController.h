//
//  SelectTradeableSpyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Spy;


@protocol SelectTradeableSpyControllerDelegate

- (void)spySelected:(Spy *)spy;

@end


@interface SelectTradeableSpyController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectTradeableSpyControllerDelegate> delegate;


+ (SelectTradeableSpyController *) create;


@end

//
//  SelectSpyFromListController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Spy;


@protocol SelectSpyFromListControllerDelegate

- (void)spySelected:(Spy *)spy;

@end


@interface SelectSpyFromListController : LETableViewControllerGrouped {
	NSMutableArray *spies;
	id<SelectSpyFromListControllerDelegate> delegate;
}


@property (nonatomic, copy) NSMutableArray *spies;
@property (nonatomic, assign) id<SelectSpyFromListControllerDelegate> delegate;


+ (SelectSpyFromListController *) create;


@end

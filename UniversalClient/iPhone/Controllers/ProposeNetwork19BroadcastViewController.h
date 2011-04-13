//
//  ProposeNetwork19BroadcastViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarInJurisdictionViewController.h"


@class Parliament;
@class LETableViewCellTextView;


@interface ProposeNetwork19BroadcastViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) LETableViewCellTextView *messageCell;


- (void)propose;


+ (ProposeNetwork19BroadcastViewController *)create;


@end

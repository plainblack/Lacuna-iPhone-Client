//
//  ChooseProposeTypeViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;


@interface ChooseProposeTypeViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;


+ (ChooseProposeTypeViewController *)create;


@end

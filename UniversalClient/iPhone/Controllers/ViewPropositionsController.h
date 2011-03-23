//
//  ViewPropositionsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;


@interface ViewPropositionsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;


+ (ViewPropositionsController *)create;


@end

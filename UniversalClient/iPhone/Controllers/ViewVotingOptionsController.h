//
//  ViewVotingOptionsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Entertainment;


@interface ViewVotingOptionsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Entertainment *entertainment;


+ (ViewVotingOptionsController *)create;


@end

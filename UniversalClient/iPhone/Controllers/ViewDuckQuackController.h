//
//  ViewDuckQuackController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Entertainment;


@interface ViewDuckQuackController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Entertainment *entertainment;
@property (nonatomic, retain) NSString *quackMessage;


+ (ViewDuckQuackController *) create;


@end

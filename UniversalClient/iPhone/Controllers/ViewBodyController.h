//
//  ViewBodyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewBodyController : LETableViewControllerGrouped {
	NSString *bodyId;
}


@property(nonatomic, retain) NSString *bodyId;


- (void)clear;


+ (ViewBodyController *)create;


@end

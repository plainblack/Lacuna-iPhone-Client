//
//  ViewEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LEEmpireViewProfile;


@interface ViewEmpireController : LETableViewControllerGrouped {
	LEEmpireViewProfile *leEmpireViewProfile;
}


@property(nonatomic, retain) LEEmpireViewProfile *leEmpireViewProfile;


+ (ViewEmpireController *) create;


@end

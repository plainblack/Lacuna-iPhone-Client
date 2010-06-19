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
@class Empire;


@interface ViewEmpireController : LETableViewControllerGrouped {
	LEEmpireViewProfile *leEmpireViewProfile;
	Empire *empire;
}


@property(nonatomic, retain) LEEmpireViewProfile *leEmpireViewProfile;
@property(nonatomic, retain) Empire *empire;

+ (ViewEmpireController *) create;


@end

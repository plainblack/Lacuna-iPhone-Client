//
//  ViewPlansController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class PlanetaryCommand;


@interface ViewPlansController : LETableViewControllerGrouped {
	PlanetaryCommand *planetaryCommand;
}


@property (nonatomic, retain) PlanetaryCommand *planetaryCommand;


+ (ViewPlansController *) create;


@end

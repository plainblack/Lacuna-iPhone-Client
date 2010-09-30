//
//  SelectPlanetToViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LETableViewControllerGrouped.h"


@class TempleOfTheDrajilites;


@interface SelectPlanetToViewController : LETableViewControllerGrouped {
	TempleOfTheDrajilites *templeOfTheDrajilites;
	NSMutableArray *planets;
}


@property (nonatomic, retain) TempleOfTheDrajilites *templeOfTheDrajilites;
@property (nonatomic, retain) NSMutableArray *planets;


+ (SelectPlanetToViewController *) create;


@end

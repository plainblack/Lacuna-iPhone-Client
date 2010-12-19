//
//  SelectPlanetToViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarController.h"


@class TempleOfTheDrajilites;


@interface SelectPlanetToViewController : LETableViewControllerGrouped <SelectStarControllerDelegate> {
}


@property (nonatomic, retain) TempleOfTheDrajilites *templeOfTheDrajilites;
@property (nonatomic, retain) NSString *starName;
@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSMutableArray *planets;


+ (SelectPlanetToViewController *) create;


@end

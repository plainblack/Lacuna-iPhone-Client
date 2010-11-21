//
//  ViewResearchSpeciesStatsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectEmpireController.h"


@class LibraryOfJith;


@interface ViewResearchSpeciesStatsController : LETableViewControllerGrouped <SelectEmpireControllerDelegate> {
}


@property (nonatomic, retain) LibraryOfJith *libraryOfJith;
@property (nonatomic, retain) NSDictionary *empireToResearch;
@property (nonatomic, retain) NSDictionary *racialStats;


+ (ViewResearchSpeciesStatsController *)create;


@end

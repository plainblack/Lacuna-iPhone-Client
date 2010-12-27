//
//  NewExperimentController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class GeneticsLab;


@interface NewExperimentController : LETableViewControllerGrouped <UIActionSheetDelegate> {
}


@property(nonatomic, retain) GeneticsLab *geneticsLab;
@property(nonatomic, retain) NSMutableDictionary *graft;
@property(nonatomic, retain) NSDecimalNumber *survivalOdds;
@property(nonatomic, retain) NSDecimalNumber *graftOdds;
@property(nonatomic, retain) NSDecimalNumber *essentiaCost;
@property(nonatomic, retain) NSString *selectedAffinity;


+ (NewExperimentController *) create;


@end

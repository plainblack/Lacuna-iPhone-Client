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
@class Spy;
@class PrepareExperiment;
;


@interface NewExperimentController : LETableViewControllerGrouped <UIActionSheetDelegate> {
}


@property(nonatomic, retain) GeneticsLab *geneticsLab;
@property(nonatomic, retain) PrepareExperiment *prepareExperiment;
@property(nonatomic, retain) NSMutableDictionary *graft;
@property(nonatomic, retain) NSString *selectedAffinity;
@property(nonatomic, retain) Spy *spy;


+ (NewExperimentController *) create;


@end

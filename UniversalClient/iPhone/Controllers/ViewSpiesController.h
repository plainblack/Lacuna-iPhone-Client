//
//  ViewSpiesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewSpiesController : LETableViewControllerGrouped {
	NSString *buildingId;
	NSMutableDictionary *spiesData;
	NSString *urlPart;
	NSMutableArray *spies;
	NSTimer *reloadTimer;
	NSArray *possibleAssignments;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSMutableDictionary *spiesData;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSMutableArray *spies;
@property(nonatomic, retain) NSTimer *reloadTimer;
@property(nonatomic, retain) NSArray *possibleAssignments;


+ (ViewSpiesController *) create;


@end

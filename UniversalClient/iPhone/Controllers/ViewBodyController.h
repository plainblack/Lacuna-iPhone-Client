//
//  ViewBodyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"


@class Body;


@interface ViewBodyController : LETableViewControllerGrouped <PickColonyDelegate, UIActionSheetDelegate> {
	UISegmentedControl *pageSegmentedControl;
	NSString *bodyId;
	Body *watchedBody;
	NSArray *oreKeysSorted;
	PickColonyController* pickColonyController;
	BOOL watchingSession;
	NSTimer *reloadTimer;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) Body *watchedBody;
@property(nonatomic, retain) NSArray *oreKeysSorted;
@property (nonatomic, retain) NSTimer *reloadTimer;


- (IBAction)clear;
- (IBAction)logout;


+ (ViewBodyController *)create;


@end

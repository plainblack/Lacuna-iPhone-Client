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


@interface ViewBodyController : LETableViewControllerGrouped <PickColonyDelegate> {
	UISegmentedControl *pageSegmentedControl;
	NSString *bodyId;
	Body *watchedBody;
	PickColonyController* pickColonyController;
	BOOL watchingSession;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) Body *watchedBody;


- (IBAction)clear;
- (IBAction)logout;


+ (ViewBodyController *)create;


@end

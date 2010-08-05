//
//  ViewBodyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"

@class Body;


@interface ViewBodyController : LETableViewControllerGrouped {
	UISegmentedControl *pageSegmentedControl;
	NSArray *bodyIds;
	NSInteger currentBodyIndex;
	NSString *bodyId;
	Body *watchedBody;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property(nonatomic, retain) NSArray *bodyIds;
@property(nonatomic, assign) NSInteger currentBodyIndex;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) Body *watchedBody;


- (void)clear;


+ (ViewBodyController *)create;


@end

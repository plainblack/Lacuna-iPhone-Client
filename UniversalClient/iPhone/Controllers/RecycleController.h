//
//  RecycleController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface RecycleController : LETableViewControllerGrouped {
	NSString *buildingId;
	NSString *urlPart;
	NSNumber *secondsPerResource;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSNumber *secondsPerResource;


+ (RecycleController *) create;


@end

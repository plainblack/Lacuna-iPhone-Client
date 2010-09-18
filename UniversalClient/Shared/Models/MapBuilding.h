//
//  MapBuilding.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimedActivity.h"


@interface MapBuilding : NSObject {
	NSString *id;
	NSString *buildingUrl;
	NSString *name;
	NSString *imageName;
	NSDecimalNumber *level;
	NSDecimalNumber *x;
	NSDecimalNumber *y;
	NSDecimalNumber *efficiency;
	TimedActivity *pendingBuild;
	TimedActivity *work;
	BOOL needsRefresh;
	BOOL needsReload;
	UIImage *image;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSDecimalNumber *level;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
@property (nonatomic, retain) NSDecimalNumber *efficiency;
@property (nonatomic, retain) TimedActivity *pendingBuild;
@property (nonatomic, retain) TimedActivity *work;
@property (nonatomic, assign) BOOL needsRefresh;
@property (nonatomic, assign) BOOL needsReload;
@property (nonatomic, retain) UIImage *image;


- (void)parseData:(NSDictionary *)data;
- (void)updatePendingBuild:(NSDictionary *)pendingBuildData;
- (void)updateWork:(NSDictionary *)workData;
- (void)repaired;
- (void)tick:(NSInteger)interval;


@end

//
//  ShipBuildQueueItem.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShipBuildQueueItem : NSObject {
	NSString *type;
	NSDate *dateCompleted;
}


@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *dateCompleted;


- (void)parseData:(NSDictionary *)shipBuildQueueItemData;


@end

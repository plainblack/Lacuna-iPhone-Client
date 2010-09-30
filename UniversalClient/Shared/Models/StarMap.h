//
//  StarMap.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BaseMapItem;


@interface StarMap : NSObject {
	NSCache *sectors;
	NSDate *lastUpdate;
	NSInteger numLoading;
}


@property (retain) NSCache *sectors;
@property (retain) NSDate *lastUpdate;
@property (assign) NSInteger numLoading;


- (BaseMapItem *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY;


@end

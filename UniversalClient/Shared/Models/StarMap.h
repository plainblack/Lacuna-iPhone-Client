//
//  StarMap.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Star;


@interface StarMap : NSObject {
	NSMutableDictionary *sectors;
	NSDate *lastUpdate;
}


@property (retain) NSMutableDictionary *sectors;
@property (retain) NSDate *lastUpdate;


- (Star *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY;


@end

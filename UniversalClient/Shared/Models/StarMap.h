//
//  StarMap.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StarMap : NSObject {
	NSMutableDictionary *sectors;
}


@property (retain) NSMutableDictionary *sectors;

- (NSDictionary *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY;


@end

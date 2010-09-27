//
//  Star.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMapItem.h"


@interface Star : BaseMapItem {
	NSString *id;
	NSString *color;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *color;


- (void)parseData:(NSMutableDictionary *)data;


@end

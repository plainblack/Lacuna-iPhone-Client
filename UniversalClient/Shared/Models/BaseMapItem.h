//
//  BaseMapItem.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseMapItem : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
@property (nonatomic, retain) NSString *stationId;
@property (nonatomic, retain) NSString *stationName;
@property (nonatomic, retain) NSDecimalNumber *stationX;
@property (nonatomic, retain) NSDecimalNumber *stationY;


- (void)parseData:(NSMutableDictionary *)data;


@end

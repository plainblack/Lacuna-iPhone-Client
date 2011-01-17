//
//  PrepareExeriment.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrepareExperiment : NSObject {
}


@property(nonatomic, retain) NSMutableArray *grafts;
@property(nonatomic, retain) NSDecimalNumber *survivalOdds;
@property(nonatomic, retain) NSDecimalNumber *graftOdds;
@property(nonatomic, retain) NSDecimalNumber *essentiaCost;
@property(nonatomic, assign) BOOL canExperiment;


- (void)parseData:(NSMutableDictionary *)data;


@end

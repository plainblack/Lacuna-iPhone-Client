//
//  LEStatsFindAllianceRank.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsFindAllianceRank : LERequest {
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSString *allianceName;
@property (nonatomic, retain) NSMutableArray *alliances;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sortBy:(NSString *)sortBy allianceName:(NSString *)allianceName;


@end

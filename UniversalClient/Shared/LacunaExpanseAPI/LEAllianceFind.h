//
//  LEAllianceFind.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEAllianceFind : LERequest {
	NSString *allianceName;
	NSMutableArray *alliances;
}


@property (nonatomic, retain) NSString *allianceName;
@property (nonatomic, retain) NSMutableArray *alliances;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target allianceName:(NSString *)allianceName;


@end

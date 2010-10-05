//
//  LEAllianceViewProfile.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEAllianceViewProfile : LERequest {
	NSString *allianceId;
	NSMutableDictionary *profile;
}


@property (nonatomic, retain) NSString *allianceId;
@property (nonatomic, retain) NSMutableDictionary *profile;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target allianceId:(NSString *)allianceId;


@end

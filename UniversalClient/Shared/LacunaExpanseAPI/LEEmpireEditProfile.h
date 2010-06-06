//
//  LEEmpireEditProfile.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"
#import "LEEmpireViewProfile.h"


@interface LEEmpireEditProfile : LERequest {
	NSMutableDictionary *profile;
}


@property(nonatomic, retain) NSMutableDictionary *profile;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target textKey:(NSString *)textKey text:(NSString *)text leEmpireViewProfile:(LEEmpireViewProfile *)leEmpireViewProfile;


@end

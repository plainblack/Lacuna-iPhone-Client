//
//  LEEmpireCreate.h
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireCreate : LERequest {
	NSString *name;
	NSString *password;
	NSString *password1;
	NSString *empireId;
}


@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *password1;
@property(nonatomic, retain) NSString *empireId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target name:(NSString *)name password:(NSString *)password password1:(NSString *)password1;


@end

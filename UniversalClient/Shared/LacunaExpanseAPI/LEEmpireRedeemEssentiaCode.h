//
//  LEEmpireRedeemEssentiaCode.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireRedeemEssentiaCode : LERequest {
	NSString *code;
}


@property (nonatomic, retain) NSString *code;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target code:(NSString *)code;


@end

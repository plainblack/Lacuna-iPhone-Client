//
//  LEInboxRead.h
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEInboxRead : LERequest {
	NSString *messageId;
	NSMutableDictionary *message;
}


@property(nonatomic, retain) NSString *messageId;
@property(nonatomic, retain) NSMutableDictionary *message;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target messageId:(NSString *)messageId;


@end

//
//  LEInboxView.h
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEInboxView : LERequest {
	NSDecimalNumber *page;
	NSMutableArray *messages;
	NSDecimalNumber *messageCount;
}


@property(nonatomic, retain) NSDecimalNumber *page;
@property(nonatomic, retain) NSMutableArray *messages;
@property(nonatomic, retain) NSDecimalNumber *messageCount;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target page:(NSDecimalNumber *)page;


@end

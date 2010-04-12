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
	NSNumber *page;
	NSMutableArray *messages;
}


@property(nonatomic, retain) NSNumber *page;
@property(nonatomic, retain) NSMutableArray *messages;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target page:(NSNumber *)page;


@end

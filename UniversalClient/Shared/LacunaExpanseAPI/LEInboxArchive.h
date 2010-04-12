//
//  LEInboxArchive.h
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEInboxArchive : LERequest {
	NSArray *messageIds;
	NSNumber *success;
}


@property(nonatomic, retain) NSArray *messageIds;
@property(nonatomic, retain) NSNumber *success;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target messageIds:(NSArray *)messageIds;


@end

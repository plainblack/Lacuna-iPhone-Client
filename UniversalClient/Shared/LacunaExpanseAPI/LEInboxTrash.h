//
//  LEInboxTrash.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEInboxTrash : LERequest {
}


@property(nonatomic, retain) NSArray *messageIds;
@property(nonatomic, retain) NSDecimalNumber *success;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target messageIds:(NSArray *)messageIds;


@end

//
//  LERenameBody.h
//  DKTest
//
//  Created by Kevin Runde on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LERenameBody : LERequest

@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSString *bodyName;
@property(nonatomic, retain) NSString *result;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target forBody:(NSString *)bodyId newName:(NSString *)bodyName;


@end

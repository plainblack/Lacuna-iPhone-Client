//
//  LERenameBody.h
//  DKTest
//
//  Created by Kevin Runde on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LERenameBody : LERequest {
	NSString *bodyId;
	NSString *newBodyName;
	NSString *result;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSString *newBodyName;
@property(nonatomic, retain) NSString *result;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target forBody:(NSString *)bodyId newName:(NSString *)newBodyName;


@end

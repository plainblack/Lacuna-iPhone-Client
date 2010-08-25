//
//  AllianceMember.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllianceMember : NSObject {
	NSString *empireId;
	NSString *name;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *name;


- (void)parseData:(NSDictionary *)data;


@end

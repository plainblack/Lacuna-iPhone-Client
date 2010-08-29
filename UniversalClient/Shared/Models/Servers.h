//
//  Servers.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Servers : NSObject {
	NSMutableArray *serverList;
}


@property (nonatomic, retain) NSMutableArray *serverList;


- (void)readServers;
- (void)loadServers;


@end

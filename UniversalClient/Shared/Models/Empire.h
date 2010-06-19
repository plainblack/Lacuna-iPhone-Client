//
//  Empire.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Empire : NSObject {
	NSString *description;
	NSString *status;
	NSArray *medals;
}


@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSArray *medals;


@end

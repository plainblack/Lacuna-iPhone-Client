//
//  OneForOneTrade.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OneForOneTrade : NSObject {
	NSString *haveResourceType;
	NSString *wantResourceType;
	NSDecimalNumber *quantity;
}


@property (nonatomic, retain) NSString *haveResourceType;
@property (nonatomic, retain) NSString *wantResourceType;
@property (nonatomic, retain) NSDecimalNumber *quantity;


@end

//
//  Prisoner.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Prisoner : NSObject {
	NSString *id;
	NSString *name;
	NSDate *sentenceExpiresOn;
}

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *sentenceExpiresOn;


- (void)parseData:(NSDictionary *)prisonerData;
- (BOOL)tick:(NSInteger)interval;


@end

//
//  Empire.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EmpireProfile : NSObject {
	NSString *empireDescription;
	NSString *status;
	NSArray *medals;
	NSString *city;
	NSString *country;
	NSString *skype;
	NSString *playerName;
	NSString *email;
	NSString *sitterPassword;
	NSString *notes;
}


@property (nonatomic, retain) NSString *empireDescription;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSArray *medals;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *skype;
@property (nonatomic, retain) NSString *playerName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *sitterPassword;
@property (nonatomic, retain) NSString *notes;


- (void)parseData:(NSDictionary *)data;


@end

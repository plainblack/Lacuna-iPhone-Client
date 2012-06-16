//
//  Empire.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EmpireProfile : NSObject {
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
@property (nonatomic, assign) BOOL skipHappinessWarnings;
@property (nonatomic, assign) BOOL skipResourceWarnings;
@property (nonatomic, assign) BOOL skipPollutionWarnings;
@property (nonatomic, assign) BOOL skipMedalMessages;
@property (nonatomic, assign) BOOL skipFacebookWallPosts;
@property (nonatomic, assign) BOOL skipFoundNothing;
@property (nonatomic, assign) BOOL skipExcavatorResources;
@property (nonatomic, assign) BOOL skipExcavatorGlyph;
@property (nonatomic, assign) BOOL skipExcavatorPlan;
@property (nonatomic, assign) BOOL skipSpyRecovery;
@property (nonatomic, assign) BOOL skipProbeDetected;
@property (nonatomic, assign) BOOL skipAttackMessages;
@property (nonatomic, assign) BOOL skipExcavatorReplaceMsg;
@property (nonatomic, assign) BOOL dontReplaceExcavator;


- (void)parseData:(NSDictionary *)data;


@end

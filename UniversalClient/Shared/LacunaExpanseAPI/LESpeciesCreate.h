//
//  LESpeciesCreate.h
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LESpeciesCreate : LERequest {
	NSString *empireId;
	NSString *name;
	NSString *description;
	NSArray *habitableOrbits;
	NSDecimalNumber *constructionAffinity;
	NSDecimalNumber *deceptionAffinity;
	NSDecimalNumber *researchAffinity;
	NSDecimalNumber *managementAffinity;
	NSDecimalNumber *farmingAffinity;
	NSDecimalNumber *miningAffinity;
	NSDecimalNumber *scienceAffinity;
	NSDecimalNumber *environmentalAffinity;
	NSDecimalNumber *politicalAffinity;
	NSDecimalNumber *tradeAffinity;
	NSDecimalNumber *growthAffinity;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSArray *habitableOrbits;
@property(nonatomic, retain) NSDecimalNumber *constructionAffinity;
@property(nonatomic, retain) NSDecimalNumber *deceptionAffinity;
@property(nonatomic, retain) NSDecimalNumber *researchAffinity;
@property(nonatomic, retain) NSDecimalNumber *managementAffinity;
@property(nonatomic, retain) NSDecimalNumber *farmingAffinity;
@property(nonatomic, retain) NSDecimalNumber *miningAffinity;
@property(nonatomic, retain) NSDecimalNumber *scienceAffinity;
@property(nonatomic, retain) NSDecimalNumber *environmentalAffinity;
@property(nonatomic, retain) NSDecimalNumber *politicalAffinity;
@property(nonatomic, retain) NSDecimalNumber *tradeAffinity;
@property(nonatomic, retain) NSDecimalNumber *growthAffinity;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireId:(NSString *)empireId
						   name:(NSString*) name description:(NSString *) description
				habitableOrbits:(NSArray *) habitableOrbits
		   constructionAffinity:(NSDecimalNumber *) constructionAffinity deceptionAffinity:(NSDecimalNumber *) deceptionAffinity
			   researchAffinity:(NSDecimalNumber *) researchAffinity managementAffinity:(NSDecimalNumber *) managementAffinity
				farmingAffinity:(NSDecimalNumber *) farmingAffinity miningAffinity:(NSDecimalNumber *) miningAffinity
				scienceAffinity:(NSDecimalNumber *) scienceAffinity environmentalAffinity:(NSDecimalNumber *) environmentalAffinity
			  politicalAffinity:(NSDecimalNumber *) politicalAffinity tradeAffinity:(NSDecimalNumber *) tradeAffinity
				 growthAffinity:(NSDecimalNumber *) growthAffinity;


@end

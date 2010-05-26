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
	NSNumber *constructionAffinity;
	NSNumber *deceptionAffinity;
	NSNumber *researchAffinity;
	NSNumber *managementAffinity;
	NSNumber *farmingAffinity;
	NSNumber *miningAffinity;
	NSNumber *scienceAffinity;
	NSNumber *environmentalAffinity;
	NSNumber *politicalAffinity;
	NSNumber *tradeAffinity;
	NSNumber *growthAffinity;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSArray *habitableOrbits;
@property(nonatomic, retain) NSNumber *constructionAffinity;
@property(nonatomic, retain) NSNumber *deceptionAffinity;
@property(nonatomic, retain) NSNumber *researchAffinity;
@property(nonatomic, retain) NSNumber *managementAffinity;
@property(nonatomic, retain) NSNumber *farmingAffinity;
@property(nonatomic, retain) NSNumber *miningAffinity;
@property(nonatomic, retain) NSNumber *scienceAffinity;
@property(nonatomic, retain) NSNumber *environmentalAffinity;
@property(nonatomic, retain) NSNumber *politicalAffinity;
@property(nonatomic, retain) NSNumber *tradeAffinity;
@property(nonatomic, retain) NSNumber *growthAffinity;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireId:(NSString *)empireId
						   name:(NSString*) name description:(NSString *) description
				habitableOrbits:(NSArray *) habitableOrbits
		   constructionAffinity:(NSNumber *) constructionAffinity deceptionAffinity:(NSNumber *) deceptionAffinity
			   researchAffinity:(NSNumber *) researchAffinity managementAffinity:(NSNumber *) managementAffinity
				farmingAffinity:(NSNumber *) farmingAffinity miningAffinity:(NSNumber *) miningAffinity
				scienceAffinity:(NSNumber *) scienceAffinity environmentalAffinity:(NSNumber *) environmentalAffinity
			  politicalAffinity:(NSNumber *) politicalAffinity tradeAffinity:(NSNumber *) tradeAffinity
				 growthAffinity:(NSNumber *) growthAffinity;


@end

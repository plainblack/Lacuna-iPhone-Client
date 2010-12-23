//
//  LEEmpireRedefineSpecies.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LERequest.h"


@interface LEEmpireRedefineSpecies : LERequest {
}


@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSDecimalNumber *minOrbit;
@property(nonatomic, retain) NSDecimalNumber *maxOrbit;
@property(nonatomic, retain) NSDecimalNumber *manufacturingAffinity;
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


- (LERequest *)initWithCallback:(SEL)callback
						 target:(NSObject *)target
						   name:(NSString*) name
					description:(NSString *) description
					   minOrbit:(NSDecimalNumber *) minOrbit
					   maxOrbit:(NSDecimalNumber *) maxOrbit
		  manufacturingAffinity:(NSDecimalNumber *) manufacturingAffinity
			  deceptionAffinity:(NSDecimalNumber *) deceptionAffinity
			   researchAffinity:(NSDecimalNumber *) researchAffinity
			 managementAffinity:(NSDecimalNumber *) managementAffinity
				farmingAffinity:(NSDecimalNumber *) farmingAffinity
				 miningAffinity:(NSDecimalNumber *) miningAffinity
				scienceAffinity:(NSDecimalNumber *) scienceAffinity
		  environmentalAffinity:(NSDecimalNumber *) environmentalAffinity
			  politicalAffinity:(NSDecimalNumber *) politicalAffinity
				  tradeAffinity:(NSDecimalNumber *) tradeAffinity
				 growthAffinity:(NSDecimalNumber *) growthAffinity;


@end

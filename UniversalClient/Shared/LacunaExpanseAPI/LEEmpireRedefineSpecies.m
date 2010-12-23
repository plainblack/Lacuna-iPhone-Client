//
//  LEEmpireRedefineSpecies.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireRedefineSpecies.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEEmpireRedefineSpecies


@synthesize name;
@synthesize description;
@synthesize minOrbit;
@synthesize maxOrbit;
@synthesize manufacturingAffinity;
@synthesize deceptionAffinity;
@synthesize researchAffinity;
@synthesize managementAffinity;
@synthesize farmingAffinity;
@synthesize miningAffinity;
@synthesize scienceAffinity;
@synthesize environmentalAffinity;
@synthesize politicalAffinity;
@synthesize tradeAffinity;
@synthesize growthAffinity;


- (LERequest *)initWithCallback:(SEL)inCallback
						 target:(NSObject *)inTarget
						   name:(NSString*) inName
					description:(NSString *) inDescription
					   minOrbit:(NSDecimalNumber *) inMinOrbit
					   maxOrbit:(NSDecimalNumber *) inMaxOrbit
		  manufacturingAffinity:(NSDecimalNumber *) inManufacturingAffinity
			  deceptionAffinity:(NSDecimalNumber *) inDeceptionAffinity
			   researchAffinity:(NSDecimalNumber *) inResearchAffinity
			 managementAffinity:(NSDecimalNumber *) inManagementAffinity
				farmingAffinity:(NSDecimalNumber *) inFarmingAffinity
				 miningAffinity:(NSDecimalNumber *) inMiningAffinity
				scienceAffinity:(NSDecimalNumber *) inScienceAffinity
		  environmentalAffinity:(NSDecimalNumber *) inEnvironmentalAffinity
			  politicalAffinity:(NSDecimalNumber *) inPoliticalAffinity
				  tradeAffinity:(NSDecimalNumber *) inTradeAffinity
				 growthAffinity:(NSDecimalNumber *) inGrowthAffinity {
	self.name = inName;
	self.description = inDescription;
	self.minOrbit = inMinOrbit;
	self.maxOrbit = inMaxOrbit;
	self.manufacturingAffinity = inManufacturingAffinity;
	self.deceptionAffinity = inDeceptionAffinity;
	self.researchAffinity = inResearchAffinity;
	self.managementAffinity = inManagementAffinity;
	self.farmingAffinity = inFarmingAffinity;
	self.miningAffinity = inMiningAffinity;
	self.scienceAffinity = inScienceAffinity;
	self.environmentalAffinity = inEnvironmentalAffinity;
	self.politicalAffinity = inPoliticalAffinity;
	self.tradeAffinity = inTradeAffinity;
	self.growthAffinity = inGrowthAffinity;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	NSDictionary *speciesParams = _dict(self.name, @"name", self.description, @"description", self.minOrbit, @"min_orbit", self.maxOrbit, @"max_orbit", self.manufacturingAffinity, @"manufacturing_affinity", self.deceptionAffinity, @"deception_affinity", self.researchAffinity, @"research_affinity", self.managementAffinity, @"management_affinity", self.farmingAffinity, @"farming_affinity", self.miningAffinity, @"mining_affinity", self.scienceAffinity, @"science_affinity", self.environmentalAffinity, @"environmental_affinity", self.politicalAffinity, @"political_affinity", self.tradeAffinity, @"trade_affinity", self.growthAffinity, @"growth_affinity");
	NSArray *tmp = _array(session.sessionId, speciesParams);
	return tmp;
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"redefine_species";
}


- (void)dealloc {
	self.name = nil;
	self.description = nil;
	self.minOrbit = nil;
	self.maxOrbit = nil;
	self.manufacturingAffinity = nil;
	self.deceptionAffinity = nil;
	self.researchAffinity = nil;
	self.managementAffinity = nil;
	self.farmingAffinity = nil;
	self.miningAffinity = nil;
	self.scienceAffinity = nil;
	self.environmentalAffinity = nil;
	self.politicalAffinity = nil;
	self.tradeAffinity = nil;
	self.growthAffinity = nil;
	
	[super dealloc];
}


@end

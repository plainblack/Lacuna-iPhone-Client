//
//  LESpeciesCreate.m
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LESpeciesCreate.h"
#import "LEMacros.h"


@implementation LESpeciesCreate


@synthesize empireId;
@synthesize name;
@synthesize description;
@synthesize habitableOrbits;
@synthesize constructionAffinity;
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


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireId:(NSString *)inEmpireId
						   name:(NSString*) inName description:(NSString *) inDescription
				habitableOrbits:(NSArray *) inHabitableOrbits
		   constructionAffinity:(NSNumber *) inConstructionAffinity deceptionAffinity:(NSNumber *) inDeceptionAffinity
			   researchAffinity:(NSNumber *) inResearchAffinity managementAffinity:(NSNumber *) inManagementAffinity
				farmingAffinity:(NSNumber *) inFarmingAffinity miningAffinity:(NSNumber *) inMiningAffinity
				scienceAffinity:(NSNumber *) inScienceAffinity environmentalAffinity:(NSNumber *) inEnvironmentalAffinity
			  politicalAffinity:(NSNumber *) inPoliticalAffinity tradeAffinity:(NSNumber *) inTradeAffinity
				 growthAffinity:(NSNumber *) inGrowthAffinity {
	self.empireId = inEmpireId;
	self.name = inName;
	self.description = inDescription;
	self.habitableOrbits = inHabitableOrbits;
	self.constructionAffinity = inConstructionAffinity;
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
	NSDictionary *speciesParams = dict_(name, @"name", description, @"description", habitableOrbits, @"habitable_orbits", constructionAffinity, @"manufacturing_affinity", deceptionAffinity, @"deception_affinity", researchAffinity, @"research_affinity", managementAffinity, @"management_affinity", farmingAffinity, @"farming_affinity", miningAffinity, @"mining_affinity", scienceAffinity, @"science_affinity", environmentalAffinity, @"environmental_affinity", politicalAffinity, @"political_affinity", tradeAffinity, @"trade_affinity", growthAffinity, @"growth_affinity");
	NSArray *tmp = array_(self.empireId, speciesParams);
	NSLog(@"Species Params: %@", speciesParams);
	NSLog(@"Creating species: %@", tmp);
	return tmp;
}


- (void)processSuccess {
	NSLog(@"Success: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"species";
}


- (NSString *)methodName {
	return @"create";
}


- (void)dealloc {
	self.empireId = nil;
	self.name = nil;
	self.description = nil;
	self.habitableOrbits = nil;
	self.constructionAffinity = nil;
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

//
//  LEBuildingResearchSpecies.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingResearchSpecies : LERequest {
}

@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSSeting empireId;
@property (nonatomic, retain) NSMutableDictionary *speciesData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end

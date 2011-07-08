//
//  LEBuildingRenameSpecies.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRenameSpecies : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *speciesName;
@property (nonatomic, retain) NSString *speciesDescription;
@property (nonatomic, assign) BOOL success;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl speciesName:(NSString *)speciesName speciesDescription:(NSString *)speciesDescription;


@end

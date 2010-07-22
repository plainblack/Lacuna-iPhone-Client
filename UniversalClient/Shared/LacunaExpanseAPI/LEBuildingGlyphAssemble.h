//
//  LEBuildingGlyphAssemble.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGlyphAssemble : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSArray *glyphIds;
	NSString *itemName;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSArray *glyphIds;
@property(nonatomic, retain) NSString *itemName;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl glyphIds:(NSArray *)glyphIds;


@end

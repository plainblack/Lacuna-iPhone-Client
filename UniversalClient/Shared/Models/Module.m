//
//  Module.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "Module.h"
#import "LEMacros.h"


@implementation Module


//JT HAD ME REENABLE ALL OF THESE. So do we even need this class anymore? I will keep it for now.
//- (void)generateSections {
//	self.sections = _array([self generateProductionSection], [self generateHealthSection], [self generateGeneralInfoSection]);
//}
//
//
//- (NSMutableDictionary *)generateHealthSection {
//	if (_intv(self.efficiency) < 100) {
//		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_HEALTH], @"type", @"Health", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_EFFICENCY], [NSDecimalNumber numberWithInt:BUILDING_ROW_REPAIR_COST]), @"rows");
//	} else {
//		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_HEALTH], @"type", @"Health", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_EFFICENCY]), @"rows");
//	}
//}


@end

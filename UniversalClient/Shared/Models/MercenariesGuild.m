//
//  MercenariesGuild.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/26/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "MercenariesGuild.h"
#import "LEMacros.h"
#import "Util.h"
#import "MarketTrade.h"
#import "NewSpyTradeController.h"
#import "LEBuildingAddToSpyMarket.h"


@implementation MercenariesGuild


#pragma mark -
#pragma mark Object Methods

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	if (self.maxCargoSize) {
		[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_CARGO_SIZE]];
	}
	
	self.sections = _array(productionSection);
	
    self.usesEssentia = YES;
    self.selectTradeShip = YES;
	
    NSMutableArray *rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MARKET], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_MARKET], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_TRADE_FOR_MARKET]);
    [self.sections addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_MARKET], @"type", @"Market", @"name", rows, @"rows")];
	
	[self.sections addObject:[self generateHealthSection]];
	[self.sections addObject:[self generateUpgradeSection]];
	[self.sections addObject:[self generateGeneralInfoSection]];
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_CREATE_TRADE_FOR_MARKET:
			; //DO NOT REMOVE
			NewSpyTradeController *newSpyTradeController = [NewSpyTradeController create];
			newSpyTradeController.baseTradeBuilding = self;
			return newSpyTradeController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Market Instance Methods

- (void)postMarketTrade:(MarketTrade *)trade target:(id)target callback:(SEL)callback {
	self->postToMarketTarget = target;
	self->postToMarketCallback = callback;
	[[[LEBuildingAddToSpyMarket alloc] initWithCallback:@selector(addedToMarket:) target:self buildingId:self.id buildingUrl:self.buildingUrl askEssentia:trade.askEssentia offer:trade.offer tradeShipId:trade.tradeShipId] autorelease];
}


@end

//
//  BaseTradeBuilding.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseTradeBuilding.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Trade.h"
#import "ItemPush.h"
#import "LEBuildingViewAvailableTrades.h";
#import "LEBuildingViewMyTrades.h";
#import "LEBuildingPushItems.h"
#import "LETableViewCellButton.h";
#import "ViewAvailableTradesController.h"
#import "ViewMyTradesController.h"


@implementation BaseTradeBuilding


@synthesize availableTradePageNumber;
@synthesize availableTradeCount;
@synthesize availableTradesUpdated;
@synthesize availableTrades;
@synthesize myTradePageNumber;
@synthesize myTradeCount;
@synthesize myTradesUpdated;
@synthesize myTrades;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.availableTradeCount = nil;
	self.availableTradesUpdated = nil;
	self.availableTrades = nil;
	self.myTradeCount = nil;
	self.myTradesUpdated = nil;
	self.myTrades = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableArray *rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_AVAILABLE_TRADES], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_TRADES], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_TRADE]);
	
	Session *session = [Session sharedInstance];
	if ([session.empire.planets count] > 1) {
		[rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_PUSH_ITEMS]];
	}
	if ([self.buildingUrl isEqualToString:TRANSPORTER_URL]) {
		[rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_1_FOR_1_TRADE]];
	}
	
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", rows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
		case BUILDING_ROW_VIEW_MY_TRADES:
		case BUILDING_ROW_PUSH_ITEMS:
		case BUILDING_ROW_CREATE_TRADE:
		case BUILDING_ROW_1_FOR_1_TRADE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *availableTradesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			availableTradesButtonCell.textLabel.text = @"Available Trades";
			cell = availableTradesButtonCell;
			break;
		case BUILDING_ROW_VIEW_MY_TRADES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *myTradesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			myTradesButtonCell.textLabel.text = @"My Trades";
			cell = myTradesButtonCell;
			break;
		case BUILDING_ROW_PUSH_ITEMS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *pushItemsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			pushItemsButtonCell.textLabel.text = @"Push Items";
			cell = pushItemsButtonCell;
			break;
		case BUILDING_ROW_CREATE_TRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *createTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			createTradeButtonCell.textLabel.text = @"Create Trade";
			cell = createTradeButtonCell;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *oneForOneTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			oneForOneTradeButtonCell.textLabel.text = @"1 for 1 Trade With Lacunans";
			cell = oneForOneTradeButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
			; //DO NOT REMOVE
			ViewAvailableTradesController *viewAvailableTradesController = [ViewAvailableTradesController create];
			viewAvailableTradesController.baseTradeBuilding = self;
			return viewAvailableTradesController;
			break;
		case BUILDING_ROW_VIEW_MY_TRADES:
			; //DO NOT REMOVE
			ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			viewMyTradesController.baseTradeBuilding = self;
			return viewMyTradesController;
			break;
		case BUILDING_ROW_PUSH_ITEMS:
			; //DO NOT REMOVE
			/*
			ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			viewMyTradesController.baseTradeBuilding = self;
			return viewMyTradesController;
			*/
			NSLog(@"KEVIN CREATE PUSH UI");
			return nil;
			break;
		case BUILDING_ROW_CREATE_TRADE:
			; //DO NOT REMOVE
			/*
			 ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			 viewMyTradesController.baseTradeBuilding = self;
			 return viewMyTradesController;
			 */
			NSLog(@"KEVIN CREATE CREATE TRADE UI");
			return nil;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DO NOT REMOVE
			/*
			 ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			 viewMyTradesController.baseTradeBuilding = self;
			 return viewMyTradesController;
			 */
			NSLog(@"KEVIN CREATE 1 FOR 1 TRADE UI");
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)loadAvailableTradesForPage:(NSInteger)pageNumber {
	self.availableTradePageNumber = pageNumber;
	[[[LEBuildingViewAvailableTrades alloc] initWithCallback:@selector(availableTradesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousAvailableTradePage {
	return (self.availableTradePageNumber > 1);
}


- (bool)hasNextAvailableTradePage {
	return (self.availableTradePageNumber < [Util numPagesForCount:self.availableTradePageNumber]);
}


- (void)loadMyTradesForPage:(NSInteger)pageNumber {
	self.availableTradePageNumber = pageNumber;
	[[[LEBuildingViewMyTrades alloc] initWithCallback:@selector(myTradesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousMyTradePage {
	return (self.myTradePageNumber > 1);
}


- (bool)hasNextMyTradePage {
	return (self.myTradePageNumber < [Util numPagesForCount:self.myTradePageNumber]);
}


- (void)pushItems:(ItemPush *)itemPush {
	[[[LEBuildingPushItems alloc] initWithCallback:@selector(myTradesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl targetId:itemPush.targetId items:itemPush.items] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)availableTradesLoaded:(LEBuildingViewAvailableTrades *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.availableTrades count]];
	for (NSDictionary *tradeData in request.availableTrades) {
		Trade *tmpTrade = [[[Trade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.availableTrades = tmpTrades;
	
	self.availableTradeCount = request.tradeCount;
	self.availableTradesUpdated = [NSDate date];
	return nil;
}


- (id)myTradesLoaded:(LEBuildingViewMyTrades *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.myTrades count]];
	for (NSDictionary *tradeData in request.myTrades) {
		Trade *tmpTrade = [[[Trade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.myTrades = tmpTrades;
	
	self.myTradeCount = request.tradeCount;
	self.myTradesUpdated = [NSDate date];
	return nil;
}


@end

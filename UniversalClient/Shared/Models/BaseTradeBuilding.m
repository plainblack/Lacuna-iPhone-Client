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
#import "MarketTrade.h"
#import "ItemPush.h"
#import "OneForOneTrade.h"
#import "Glyph.h"
#import "Plan.h"
#import "Prisoner.h"
#import "Spy.h"
#import "Ship.h"
#import "LEBuildingViewAvailableTrades.h"
#import "LEBuildingPushItems.h"
#import "LEBuildingTradeOneForOne.h"
#import "LEBuildingGetTradeableGlyphs.h"
#import "LEBuildingGetTradeablePlans.h"
#import "LEBuildingGetTradeablePrisoners.h"
#import "LEBuildingGetTradeableShips.h"
#import "LEBuildingGetTradeableStoredResources.h"
#import "LEBuildingGetTradeableSpies.h"
#import "LEBuildingGetTradeShips.h"
#import "LEBuildingAcceptFromMarket.h"
#import "LEBuildingAddToMarket.h"
#import "LEBuildingViewMarket.h"
#import "LEBuildingViewMyMarket.h"
#import "LEBuildingWithdrawFromMarket.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "NewItemPushController.h"
#import "NewOneForOneTradeController.h"
#import "NewTradeForMarketController.h"
#import "ViewMarketController.h"
#import "ViewMyMarketController.h"


@implementation BaseTradeBuilding


@synthesize marketPageNumber;
@synthesize marketFilter;
@synthesize marketTradeCount;
@synthesize marketUpdated;
@synthesize marketTrades;
@synthesize myMarketPageNumber;
@synthesize myMarketTradeCount;
@synthesize myMarketUpdated;
@synthesize myMarketTrades;

@synthesize glyphs;
@synthesize glyphsById;
@synthesize cargoUsedPerGlyph;
@synthesize plans;
@synthesize plansById;
@synthesize cargoUsedPerPlan;
@synthesize prisoners;
@synthesize prisonersById;
@synthesize cargoUsedPerPrisoner;
@synthesize spies;
@synthesize spiesById;
@synthesize cargoUsedPerSpy;
@synthesize resourceTypes;
@synthesize ships;
@synthesize shipsById;
@synthesize cargoUsedPerShip;
@synthesize storedResources;
@synthesize cargoUsedPerStoredResource;
@synthesize usesEssentia;
@synthesize selectTradeShip;
@synthesize spiesOnly;
@synthesize maxCargoSize;
@synthesize tradeShips;
@synthesize tradeShipsById;
@synthesize tradeShipsTravelTime;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.marketFilter = nil;
	self.marketTradeCount = nil;
	self.marketUpdated = nil;
	self.marketTrades = nil;
	self.myMarketTradeCount = nil;
	self.myMarketUpdated = nil;
	self.myMarketTrades = nil;
	
	self.glyphs = nil;
	self.glyphsById = nil;
	self.cargoUsedPerGlyph = nil;
	self.plans = nil;
	self.plansById = nil;
	self.cargoUsedPerPlan = nil;
	self.prisoners = nil;
	self.prisonersById = nil;
	self.cargoUsedPerPrisoner = nil;
	self.spies = nil;
	self.spiesById = nil;
	self.cargoUsedPerSpy = nil;
	self.resourceTypes = nil;
	self.ships = nil;
	self.shipsById = nil;
	self.cargoUsedPerShip = nil;
	self.storedResources = nil;
	self.cargoUsedPerStoredResource = nil;
	self.maxCargoSize = nil;
	self.tradeShips = nil;
	self.tradeShipsById = nil;
	self.tradeShipsTravelTime = nil;
	[super dealloc];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *transportData = [data objectForKey:@"transport"];
	if (transportData) {
		self.maxCargoSize = [Util asNumber:[transportData objectForKey:@"max"]];
	}
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	if (self.maxCargoSize) {
		[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_CARGO_SIZE]];
	}
	
	self.sections = _array(productionSection);
	
	Session *session = [Session sharedInstance];
	if ([self.buildingUrl isEqualToString:TRANSPORTER_URL]) {
		NSMutableArray *rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_1_FOR_1_TRADE]);
		if ([session.empire.planets count] > 1) {
			[rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_PUSH_ITEMS]];
		}
		[self.sections addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", rows, @"rows")];
		self->usesEssentia = YES;
		self->selectTradeShip = NO;
        self->spiesOnly = NO;
    } else if ([self.buildingUrl isEqualToString:TRADE_URL]) {
		if ([session.empire.planets count] > 1) {
			[self.sections addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_PUSH_ITEMS]), @"rows")];
		}
		self->usesEssentia = NO;
		self->selectTradeShip = YES;
        self->spiesOnly = NO;
	} else 	if ([self.buildingUrl isEqualToString:MERCENARIES_GUILD_URL]) {
		self->usesEssentia = YES;
		self->selectTradeShip = YES;
        self->spiesOnly = YES;
    }
	
    NSMutableArray *rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MARKET], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_MARKET], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_TRADE_FOR_MARKET]);
    [self.sections addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_MARKET], @"type", @"Market", @"name", rows, @"rows")];
	
	[self.sections addObject:[self generateHealthSection]];
	[self.sections addObject:[self generateUpgradeSection]];
	[self.sections addObject:[self generateGeneralInfoSection]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_PUSH_ITEMS:
		case BUILDING_ROW_1_FOR_1_TRADE:
		case BUILDING_ROW_VIEW_MARKET:
		case BUILDING_ROW_VIEW_MY_MARKET:
		case BUILDING_ROW_CREATE_TRADE_FOR_MARKET:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_MAX_CARGO_SIZE:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_PUSH_ITEMS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *pushItemsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			pushItemsButtonCell.textLabel.text = @"Push Items";
			cell = pushItemsButtonCell;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *oneForOneTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			oneForOneTradeButtonCell.textLabel.text = @"1 for 1 Trade With Lacunans";
			cell = oneForOneTradeButtonCell;
			break;
		case BUILDING_ROW_MAX_CARGO_SIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *maxCargoSizeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			maxCargoSizeCell.label.text = @"Max Cargo Size";
			maxCargoSizeCell.content.text = [Util prettyNSDecimalNumber:self.maxCargoSize];
			cell = maxCargoSizeCell;
			break;
		case BUILDING_ROW_VIEW_MARKET:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewMarketButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewMarketButtonCell.textLabel.text = @"View Market";
			cell = viewMarketButtonCell;
			break;
		case BUILDING_ROW_VIEW_MY_MARKET:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewMyMarketButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewMyMarketButtonCell.textLabel.text = @"View My Market";
			cell = viewMyMarketButtonCell;
			break;
		case BUILDING_ROW_CREATE_TRADE_FOR_MARKET:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *createTradeForMarketButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			createTradeForMarketButtonCell.textLabel.text = @"Create Trade";
			cell = createTradeForMarketButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_PUSH_ITEMS:
			; //DO NOT REMOVE
			NewItemPushController *newItemPushController = [NewItemPushController create];
			newItemPushController.baseTradeBuilding = self;
			return newItemPushController;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DO NOT REMOVE
			NewOneForOneTradeController *newOneForOneTradeController = [NewOneForOneTradeController create];
			newOneForOneTradeController.baseTradeBuilding = self;
			return newOneForOneTradeController;
			break;
		case BUILDING_ROW_VIEW_MARKET:
			; //DO NOT REMOVE
			ViewMarketController *viewMarketController = [ViewMarketController create];
			viewMarketController.baseTradeBuilding = self;
			return viewMarketController;
			break;
		case BUILDING_ROW_VIEW_MY_MARKET:
			; //DO NOT REMOVE
			ViewMyMarketController *viewMyMarketController = [ViewMyMarketController create];
			viewMyMarketController.baseTradeBuilding = self;
			return viewMyMarketController;
			break;
		case BUILDING_ROW_CREATE_TRADE_FOR_MARKET:
			; //DO NOT REMOVE
			NewTradeForMarketController *newTradeForMarketController = [NewTradeForMarketController create];
			newTradeForMarketController.baseTradeBuilding = self;
			return newTradeForMarketController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)clearLoadables {
	self.glyphs = nil;
	self.glyphsById = nil;
	self.cargoUsedPerGlyph = nil;
	self.plans = nil;
	self.plansById = nil;
	self.cargoUsedPerPlan = nil;
	self.prisoners = nil;
	self.prisonersById = nil;
	self.cargoUsedPerPrisoner = nil;
	self.spies = nil;
	self.spiesById = nil;
	self.cargoUsedPerSpy = nil;
	self.resourceTypes = nil;
	self.ships = nil;
	self.shipsById = nil;
	self.cargoUsedPerShip = nil;
	self.storedResources = nil;
	self.cargoUsedPerStoredResource = nil;
	self.tradeShips = nil;
	self.tradeShipsById = nil;
	self.tradeShipsTravelTime = nil;
}


- (void)loadTradeableGlyphs {
	[[[LEBuildingGetTradeableGlyphs alloc] initWithCallback:@selector(loadedTradeableGlyphs:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeablePlans {
	[[[LEBuildingGetTradeablePlans alloc] initWithCallback:@selector(loadedTradeablePlans:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeablePrisoners {
	[[[LEBuildingGetTradeablePrisoners alloc] initWithCallback:@selector(loadedTradeablePrisoners:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeableSpies {
	[[[LEBuildingGetTradeableSpies alloc] initWithCallback:@selector(loadedTradeableSpies:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeableResourceTypes {
	self.resourceTypes = _array( @"cheese", @"water", @"energy", @"waste", @"essentia", @"bean", @"lapis", @"potato", @"apple", @"root", @"corn", @"cider", @"wheat", @"bread", @"soup", @"chip", @"pie", @"pancake", @"milk", @"meal", @"algae", @"syrup", @"fungus", @"burger", @"shake", @"beetle", @"rutile", @"chromite", @"chalcopyrite", @"galena", @"gold", @"uraninite", @"bauxite", @"goethite", @"halite", @"gypsum", @"trona", @"kerogen", @"methane", @"anthracite", @"sulfur", @"zircon", @"monazite", @"fluorite", @"beryl", @"magnetite");
}

- (void)loadTradeableShips {
	[[[LEBuildingGetTradeableShips alloc] initWithCallback:@selector(loadedTradeableShips:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeableStoredResources {
	[[[LEBuildingGetTradeableStoredResources alloc] initWithCallback:@selector(loadedTradeableStoredResources:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeShipsToBody:(NSString *)targetBodyId {
	[[[LEBuildingGetTradeShips alloc] initWithCallback:@selector(loadedTradeShips:) target:self buildingId:self.id buildingUrl:self.buildingUrl targetBodyId:targetBodyId] autorelease];
}


- (void)removeTradeableStoredResource:(NSDictionary *)storedResource {
	__block NSDictionary *toDelete = nil; 
	NSString *toRemoveType = [storedResource objectForKey:@"type"];
	NSDecimalNumber *toRemoveQuantity = [storedResource objectForKey:@"quantity"];
	[self.storedResources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([[obj objectForKey:@"type"] isEqualToString:toRemoveType]) {
			NSInteger tmp = [[Util asNumber:[obj objectForKey:@"quantity"]] compare:toRemoveQuantity];
			if (tmp == NSOrderedDescending) {
				NSDecimalNumber *currentLevel = [Util asNumber:[obj objectForKey:@"quantity"]];
				NSDecimalNumber *leftOver = [currentLevel decimalNumberBySubtracting:toRemoveQuantity];
				[obj setObject:leftOver forKey:@"quantity"];
			} else if (tmp == NSOrderedSame) {
				toDelete = obj;
			}
			*stop = YES;
		}
	}];
	if (toDelete) {
		[self.storedResources removeObject:toDelete];
	}
}


- (void)addTradeableStoredResource:(NSDictionary *)storedResource {
	__block BOOL found = NO; 
	[self.storedResources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([[obj objectForKey:@"type"] isEqualToString:[storedResource objectForKey:@"type"]]) {
			NSDecimalNumber *currentLevel = [obj objectForKey:@"quantity"];
			NSDecimalNumber *toAdd = [storedResource objectForKey:@"quantity"];
			NSDecimalNumber *newLevel = [currentLevel decimalNumberByAdding:toAdd];
			[obj setObject:newLevel forKey:@"quantity"];
			found = YES;
			*stop = YES;
		}
	}];
	if (!found) {
		[self.storedResources addObject:storedResource];
	}
}


- (NSDecimalNumber *)calculateStorageForGlyphs:(NSInteger)numGlyphs plans:(NSInteger)numPlans prisoners:(NSInteger)numPrisoners spies:(NSInteger) numSpies storedResources:(NSDecimalNumber *)numStoredResources ships:(NSInteger)numShips {
	NSDecimalNumber *total = [NSDecimalNumber zero];
	if (numGlyphs > 0) {
		total = [total decimalNumberByAdding:[self.cargoUsedPerGlyph decimalNumberByMultiplyingBy:[Util decimalFromInt:numGlyphs]]];
	}
	if (numPlans > 0) {
		total = [total decimalNumberByAdding:[self.cargoUsedPerPlan decimalNumberByMultiplyingBy:[Util decimalFromInt:numPlans]]];
	}
	if (numPrisoners > 0) {
		total = [total decimalNumberByAdding:[self.cargoUsedPerPrisoner decimalNumberByMultiplyingBy:[Util decimalFromInt:numPrisoners]]];
	}
	if (numSpies > 0) {
		total = [total decimalNumberByAdding:[self.cargoUsedPerSpy decimalNumberByMultiplyingBy:[Util decimalFromInt:numSpies]]];
	}
	if (_intv(numStoredResources) > 0) {
		NSDecimalNumber *tmp = [self.cargoUsedPerStoredResource decimalNumberByMultiplyingBy:numStoredResources];
		total = [total decimalNumberByAdding:tmp];
	}
	if (numShips > 0) {
		total = [total decimalNumberByAdding:[self.cargoUsedPerShip decimalNumberByMultiplyingBy:[Util decimalFromInt:numShips]]];
	}
	
	return total;
}

- (void)pushItems:(ItemPush *)itemPush target:(id)target callback:(SEL)callback {
	self->itemPushTarget = target;
	self->itemPushCallback = callback;
	[[[LEBuildingPushItems alloc] initWithCallback:@selector(pushedItems:) target:self buildingId:self.id buildingUrl:self.buildingUrl targetId:itemPush.targetId items:itemPush.items tradeShipId:itemPush.tradeShipId stayAtTarget:itemPush.stayAtTarget] autorelease];
}


- (void)tradeOneForOne:(OneForOneTrade *)oneForOneTrade target:(id)target callback:(SEL)callback {
	self->oneForOneTradeTarget = target;
	self->oneForOneTradeCallback = callback;
	[[[LEBuildingTradeOneForOne alloc] initWithCallback:@selector(tradedOneForOne:) target:self buildingId:self.id buildingUrl:self.buildingUrl haveResourceType:oneForOneTrade.haveResourceType wantResourceType:oneForOneTrade.wantResourceType quantity:oneForOneTrade.quantity] autorelease];
}


#pragma mark -
#pragma mark Market Instance Methods

- (void)loadMarketPage:(NSInteger)pageNumber filter:(NSString *)filter {
	self.marketPageNumber = pageNumber;
	self.marketFilter = filter;
	[[[LEBuildingViewMarket alloc] initWithCallback:@selector(marketLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber filter:filter] autorelease];
}


- (bool)hasPreviousMarketPage {
	return (self.marketPageNumber > 1);
}


- (bool)hasNextMarketPage {
	return (self.marketPageNumber < [Util numPagesForCount:_intv(self.marketTradeCount)]);
}


- (void)loadMyMarketPage:(NSInteger)pageNumber {
	self.myMarketPageNumber = pageNumber;
	[[[LEBuildingViewMyMarket alloc] initWithCallback:@selector(myMarketLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousMyMarketPage {
	return (self.myMarketPageNumber > 1);
}


- (bool)hasNextMyMarketPage {
	return (self.myMarketPageNumber < [Util numPagesForCount:_intv(self.myMarketTradeCount)]);
}


- (void)postMarketTrade:(MarketTrade *)trade target:(id)target callback:(SEL)callback {
	self->postToMarketTarget = target;
	self->postToMarketCallback = callback;
	[[[LEBuildingAddToMarket alloc] initWithCallback:@selector(addedToMarket:) target:self buildingId:self.id buildingUrl:self.buildingUrl askEssentia:trade.askEssentia offer:trade.offer tradeShipId:trade.tradeShipId] autorelease];
}


- (void)acceptMarketTrade:(MarketTrade *)trade target:(id)target callback:(SEL)callback {
	self->acceptFromMarketTarget = target;
	self->acceptFromMarketCallback = callback;
	[[[LEBuildingAcceptFromMarket alloc] initWithCallback:@selector(acceptedFromMarket:) target:self buildingId:self.id buildingUrl:self.buildingUrl tradeId:trade.id] autorelease];
}

- (void)withdrawMarketTrade:(MarketTrade *)trade {
	[[[LEBuildingWithdrawFromMarket alloc] initWithCallback:@selector(withdrewFromMarket:) target:self buildingId:self.id buildingUrl:self.buildingUrl tradeId:trade.id] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)loadedTradeableGlyphs:(LEBuildingGetTradeableGlyphs *)request {
	self.cargoUsedPerGlyph = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.glyphs count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.glyphs count]];
	[request.glyphs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Glyph *glyph = [[[Glyph alloc] init] autorelease];
		[glyph parseData:obj];
		[tmpArray addObject:glyph];
		[tmpDict setObject:glyph forKey:glyph.id];
	}];
	self.glyphs = tmpArray;
	self.glyphsById = tmpDict;
	return nil;
}


- (id)loadedTradeablePlans:(LEBuildingGetTradeablePlans *)request {
	self.cargoUsedPerPlan = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.plans count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.plans count]];
	[request.plans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Plan *plan = [[[Plan alloc] init] autorelease];
		[plan parseData:obj];
		[tmpArray addObject:plan];
		[tmpDict setObject:plan forKey:plan.id];
	}];
	self.plans = tmpArray;
	self.plansById = tmpDict;
	return nil;
}


- (id)loadedTradeablePrisoners:(LEBuildingGetTradeablePrisoners *)request {
	self.cargoUsedPerPrisoner = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.prisoners count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.prisoners count]];
	[request.prisoners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Prisoner *prisoner = [[[Prisoner alloc] init] autorelease];
		[prisoner parseData:obj];
		[tmpArray addObject:prisoner];
		[tmpDict setObject:prisoner forKey:prisoner.id];
	}];
	self.prisoners = tmpArray;
	self.prisonersById = tmpDict;
	return nil;
}


- (id)loadedTradeableSpies:(LEBuildingGetTradeableSpies *)request {
	self.cargoUsedPerSpy = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.spies count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.spies count]];
	[request.spies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Spy *spy = [[[Spy alloc] init] autorelease];
		[spy parseData:obj];
		[tmpArray addObject:spy];
		[tmpDict setObject:spy forKey:spy.id];
	}];
	self.spies = tmpArray;
	self.spiesById = tmpDict;
	return nil;
}


- (id)loadedTradeableShips:(LEBuildingGetTradeableShips *)request {
	self.cargoUsedPerShip = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.ships count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.ships count]];
	[request.ships enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Ship *ship = [[[Ship alloc] init] autorelease];
		[ship parseData:obj];
		ship.task = @"Docked";
		[tmpArray addObject:ship];
		[tmpDict setObject:ship forKey:ship.id];
	}];
	self.ships = tmpArray;
	self.shipsById = tmpDict;
	return nil;
}


- (id)loadedTradeableStoredResources:(LEBuildingGetTradeableStoredResources *)request {
	self.cargoUsedPerStoredResource = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.storedResources count]];
	[request.storedResources enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		[tmpArray addObject:_dict(key, @"type", obj, @"quantity")];
	}];
	[tmpArray sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
	self.storedResources = tmpArray;
	return nil;
}


- (id)loadedTradeShips:(LEBuildingGetTradeShips *)request {
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.ships count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.ships count]];
	NSMutableDictionary *tmpTravelTimes = [NSMutableDictionary dictionaryWithCapacity:[request.ships count]];
	[request.ships enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Ship *ship = [[[Ship alloc] init] autorelease];
		[ship parseData:obj];
		ship.task = @"Docked";
		[tmpArray addObject:ship];
		[tmpDict setObject:ship forKey:ship.id];
		NSDecimalNumber *estimatedTravelTime = [obj objectForKey:@"estimated_travel_time"];
		if (isNull(estimatedTravelTime)) {
			estimatedTravelTime = [NSDecimalNumber zero];
			NSLog(@"Could not find estimated_travel_time in: %@", obj);
		}
		[tmpTravelTimes setObject:estimatedTravelTime forKey:ship.id];
	}];
	self.tradeShips = tmpArray;
	self.tradeShipsById = tmpDict;
	self.tradeShipsTravelTime = tmpTravelTimes;
	return nil;
}


- (id)pushedItems:(LEBuildingPushItems *)request {
	[self->itemPushTarget performSelector:self->itemPushCallback withObject:request];
	return nil;
}


- (id)tradedOneForOne:(LEBuildingTradeOneForOne *)request {
	[self->oneForOneTradeTarget performSelector:self->oneForOneTradeCallback withObject:request];
	return nil;
}


#pragma mark -
#pragma mark Market Callback Methods

- (id)marketLoaded:(LEBuildingViewMarket *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.availableTrades count]];
	for (NSDictionary *tradeData in request.availableTrades) {
		MarketTrade *tmpTrade = [[[MarketTrade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.marketTrades = tmpTrades;
	
	self.marketTradeCount = request.tradeCount;
	self.marketUpdated = [NSDate date];
	return nil;
}


- (id)myMarketLoaded:(LEBuildingViewMyMarket *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.myTrades count]];
	for (NSDictionary *tradeData in request.myTrades) {
		MarketTrade *tmpTrade = [[[MarketTrade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.myMarketTrades = tmpTrades;
	
	self.myMarketTradeCount = request.tradeCount;
	self.myMarketUpdated = [NSDate date];
	return nil;
}


- (id)addedToMarket:(LEBuildingAddToMarket *)request {
	if (![request wasError]) {
		self.myMarketTrades = nil;
		self.myMarketUpdated = nil;
	}
	[self->postToMarketTarget performSelector:self->postToMarketCallback withObject:request];
	return nil;
}


- (id)withdrewFromMarket:(LEBuildingWithdrawFromMarket *)request {
	if (![request wasError]) {
		__block MarketTrade *foundTrade;
		[self.myMarketTrades enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			MarketTrade *trade = obj;
			if ([trade.id isEqualToString:request.tradeId]) {
				foundTrade = obj;
				*stop = YES;
			}
		}];
		if (foundTrade) {
			[self.myMarketTrades removeObject:foundTrade];
			self.myMarketUpdated = [NSDate date];
		}
	}
	return nil;
}


- (id)acceptedFromMarket:(LEBuildingAcceptFromMarket *)request {
	if (![request wasError]) {
		__block MarketTrade *foundTrade;
		[self.marketTrades enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			MarketTrade *trade = obj;
			if ([trade.id isEqualToString:request.tradeId]) {
				foundTrade = obj;
				*stop = YES;
			}
		}];
		if (foundTrade) {
			[self.marketTrades removeObject:foundTrade];
			self.marketUpdated = [NSDate date];
		}
	}
	[self->acceptFromMarketTarget performSelector:self->acceptFromMarketCallback withObject:request];
	return nil;
}


@end

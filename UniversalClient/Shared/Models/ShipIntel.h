//
//  ShipIntel.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ShipIntel <NSObject>


@property (nonatomic, retain) NSMutableArray *travellingShips;
@property (nonatomic, retain) NSDate *travellingShipsUpdated;
@property (nonatomic, assign) NSInteger travellingShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numTravellingShips;
@property (nonatomic, retain) NSMutableArray *foreignShips;
@property (nonatomic, retain) NSDate *foreignShipsUpdated;
@property (nonatomic, assign) NSInteger foreignShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numForeignShips;
@property (nonatomic, retain) NSMutableArray *orbitingShips;
@property (nonatomic, retain) NSDate *orbitingShipsUpdated;
@property (nonatomic, assign) NSInteger orbitingShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numOrbitingShips;


- (void)loadTravellingShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousTravellingShipsPage;
- (bool)hasNextTravellingShipsPage;
- (void)loadForeignShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousForeignShipsPage;
- (bool)hasNextForeignShipsPage;
- (void)loadOrbitingShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousOrbitingShipsPage;
- (bool)hasNextOrbitingShipsPage;


@end

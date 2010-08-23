//
//  Trade.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Trade : NSObject {
	NSString *id;
	NSDate *dateOffered;
	NSString *askType;
	NSDecimalNumber *askQuantity;
	NSString *askDescription;
	NSString *offerType;
	NSDecimalNumber *offerQuantity;
	NSString *offerGlyphId;
	NSString *offerPlanId;
	NSString *offerPrisonerId;
	NSString *offerShipId;
	NSString *offerDescription;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSDate *dateOffered;
@property (nonatomic, retain) NSString *askType;
@property (nonatomic, retain) NSDecimalNumber *askQuantity;
@property (nonatomic, retain) NSString *askDescription;
@property (nonatomic, retain) NSString *offerType;
@property (nonatomic, retain) NSDecimalNumber *offerQuantity;
@property (nonatomic, retain) NSString *offerGlyphId;
@property (nonatomic, retain) NSString *offerPlanId;
@property (nonatomic, retain) NSString *offerPrisonerId;
@property (nonatomic, retain) NSString *offerShipId;
@property (nonatomic, retain) NSString *offerDescription;


- (void)parseData:(NSDictionary *)data;


@end

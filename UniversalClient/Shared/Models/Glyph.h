//
//  Glyph.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Glyph : NSObject {
	NSString *id;
	NSString *type;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, readonly, retain) NSString *imageName;


- (void)parseData:(NSDictionary *)data;


@end

//
//  Law.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Law : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) NSDate *dateEnacted;


- (void)parseData:(NSDictionary *)data;



@end

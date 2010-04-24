//
//  ViewNetwork19NewsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewNetwork19NewsController : LETableViewControllerGrouped {
	NSString *buildingId;
	NSString *urlPart;
	NSArray *newsItems;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSArray *newsItems;


+ (ViewNetwork19NewsController *) create;


@end

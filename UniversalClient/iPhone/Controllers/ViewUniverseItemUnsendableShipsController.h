//
//  ViewUniverseItemUnsendableShipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"


@class BaseMapItem;


@interface ViewUniverseItemUnsendableShipsController : LETableViewControllerGrouped <PickColonyDelegate> {
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) NSMutableArray *unsendableShips;
@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *sendFromBodyId;


+ (ViewUniverseItemUnsendableShipsController *)create;


@end

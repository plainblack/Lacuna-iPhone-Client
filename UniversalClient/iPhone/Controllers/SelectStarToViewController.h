//
//  SelectStarToViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarController.h"


@class OracleOfAnid;
@class Star;


@interface SelectStarToViewController : LETableViewControllerGrouped <SelectStarControllerDelegate> {
}


@property(nonatomic, retain) OracleOfAnid *oracleOfAnid;
@property(nonatomic, retain) NSString *starName;
@property(nonatomic, retain) NSString *starId;
@property(nonatomic, retain) Star *star;
@property(nonatomic, retain) NSMutableArray *bodies;


+ (SelectStarToViewController *) create;


@end

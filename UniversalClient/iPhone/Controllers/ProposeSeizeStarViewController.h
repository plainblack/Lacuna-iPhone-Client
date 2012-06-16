//
//  ProposeSeizeStar.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarController.h"


@class Parliament;


@interface ProposeSeizeStarViewController : LETableViewControllerGrouped <SelectStarControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedStar;


- (IBAction)propose;


+ (ProposeSeizeStarViewController *)create;


@end

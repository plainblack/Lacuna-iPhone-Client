//
//  SelectStarController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SelectStarControllerDelegate

- (void)selectedStar:(NSDictionary *)star;

@end


@class LETableViewCellTextEntry;


@interface SelectStarController : LETableViewControllerGrouped <UITextFieldDelegate> {
}


@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;
@property (nonatomic, assign) id<SelectStarControllerDelegate> delegate;


- (void)searchForStars:(NSString *)starName;


+ (SelectStarController *)create;


@end

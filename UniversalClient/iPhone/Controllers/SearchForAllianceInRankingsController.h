//
//  SearchForAllianceInRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SearchForAllianceInRankingsControllerDelegate

- (void)selectedAlliance:(NSDictionary *)alliance;

@end


@class LETableViewCellTextEntry;


@interface SearchForAllianceInRankingsController : LETableViewControllerGrouped <UITextFieldDelegate> {
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *alliances;
@property (nonatomic, assign) id<SearchForAllianceInRankingsControllerDelegate> delegate;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (void)searchForAlliance:(NSString *)allianceName;


+ (SearchForAllianceInRankingsController *)create;


@end

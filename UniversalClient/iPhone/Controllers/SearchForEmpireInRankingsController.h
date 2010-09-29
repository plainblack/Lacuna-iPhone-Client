//
//  SearchForEmpireInRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SearchForEmpireInRankingsControllerDelegate

- (void)selectedEmpire:(NSDictionary *)empire;

@end


@class LETableViewCellTextEntry;


@interface SearchForEmpireInRankingsController : LETableViewControllerGrouped <UITextFieldDelegate> {
	NSString *sortBy;
	NSMutableArray *empires;
	id<SearchForEmpireInRankingsControllerDelegate> delegate;
	LETableViewCellTextEntry *nameCell;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *empires;
@property (nonatomic, assign) id<SearchForEmpireInRankingsControllerDelegate> delegate;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (void)searchForEmpire:(NSString *)empireName;


+ (SearchForEmpireInRankingsController *)create;


@end

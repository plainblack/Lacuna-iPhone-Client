//
//  SearchForAllianceController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellTextEntry;


@interface SearchForAllianceController : LETableViewControllerGrouped <UITextFieldDelegate> {
	NSMutableArray *alliances;
	LETableViewCellTextEntry *nameCell;
}


@property (nonatomic, retain) NSMutableArray *alliances;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (void)searchForAlliance:(NSString *)allianceName;


+ (SearchForAllianceController *)create;


@end

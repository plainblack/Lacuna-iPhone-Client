//
//  SelectEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SelectEmpireControllerDelegate

- (void)selectedEmpire:(NSDictionary *)empire;

@end


@class LETableViewCellTextEntry;


@interface SelectEmpireController : LETableViewControllerGrouped <UITextFieldDelegate> {
	NSMutableArray *empires;
	id<SelectEmpireControllerDelegate> delegate;
	LETableViewCellTextEntry *nameCell;
}


@property (nonatomic, retain) NSMutableArray *empires;
@property (nonatomic, assign) id<SelectEmpireControllerDelegate> delegate;
@property (nonatomic, assign) LETableViewCellTextEntry *nameCell;


- (void)searchForEmpire:(NSString *)empireName;


+ (SelectEmpireController *)create;


@end

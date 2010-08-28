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


@interface SelectEmpireController : LETableViewControllerGrouped <UITextFieldDelegate> {
	NSMutableArray *empires;
	id<SelectEmpireControllerDelegate> delegate;
}


@property (nonatomic, retain) NSMutableArray *empires;
@property (nonatomic, assign) id<SelectEmpireControllerDelegate> delegate;


- (void)searchForEmpire:(NSString *)empireName;


+ (SelectEmpireController *)create;


@end

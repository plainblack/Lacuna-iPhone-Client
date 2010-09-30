//
//  UniverseGotoController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol UniverseGotoControllerDelegate

- (void)selectedGridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *) gridY;

@end


@class LETableViewCellTextEntry;


@interface UniverseGotoController : LETableViewControllerGrouped <UITextFieldDelegate> {
	NSMutableArray *stars;
	id<UniverseGotoControllerDelegate> delegate;
	LETableViewCellTextEntry *starNameCell;
}


@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, assign) id<UniverseGotoControllerDelegate> delegate;
@property (nonatomic, retain) LETableViewCellTextEntry *starNameCell;


- (void)searchForStar:(NSString *)starName;


+ (UniverseGotoController *)create;


@end

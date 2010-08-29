//
//  SelectServerController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Servers;
@class LETableViewCellTextEntry;


@protocol SelectServerControllerDelegate

- (void)selectedServer:(NSDictionary *)server;

@end


@interface SelectServerController : LETableViewControllerGrouped <UITextFieldDelegate> {
	Servers *servers;
	id<SelectServerControllerDelegate> delegate;
	LETableViewCellTextEntry *customerServerCell;
}


@property (nonatomic, retain) Servers *servers;
@property (nonatomic, assign) id<SelectServerControllerDelegate> delegate;
@property (nonatomic, assign) LETableViewCellTextEntry *customerServerCell;


- (IBAction)cancel;


+ (SelectServerController *)create;


@end

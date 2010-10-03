//
//  ConfirmNewEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellButton;


@interface FoundNewEmpireController : LETableViewControllerGrouped {
	LETableViewCellButton *foundButtonCell;
	NSString *empireId;
	NSString *username;
	NSString *password;
}


@property (nonatomic, retain) LETableViewCellButton *foundButtonCell;
@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;


- (IBAction)cancel;


+ (FoundNewEmpireController *) create;


@end

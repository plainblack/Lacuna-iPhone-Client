//
//  SelectEmpireSpeciesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface SelectNewEmpireSpeciesController : LETableViewControllerGrouped {
	NSString *empireId;
	NSString *username;
	NSString *password;
}


@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;


- (IBAction)cancel;


+ (SelectNewEmpireSpeciesController *)create;


@end

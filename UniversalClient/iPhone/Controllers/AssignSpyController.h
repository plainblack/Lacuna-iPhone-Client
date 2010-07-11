//
//  AssignSpyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Intelligence;
@class Spy;


@interface AssignSpyController : LETableViewControllerGrouped <UIPickerViewDelegate, UIPickerViewDataSource> {
	Intelligence *intelligenceBuilding;
	Spy *spy;
	UIPickerView *assignmentPicker;
}


@property(nonatomic, retain) Intelligence *intelligenceBuilding;
@property(nonatomic, retain) Spy *spy;
@property(nonatomic, retain) UIPickerView *assignmentPicker;


+ (AssignSpyController *) create;


@end

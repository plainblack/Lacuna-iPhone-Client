//
//  AssignSpyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface AssignSpyController : LETableViewControllerGrouped <UIPickerViewDelegate, UIPickerViewDataSource> {
	NSString *buildingId;
	NSMutableDictionary *spyData;
	NSString *urlPart;
	NSArray *possibleAssignments;
	UIPickerView *assignmentPicker;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSMutableDictionary *spyData;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSArray *possibleAssignments;
@property(nonatomic, retain) UIPickerView *assignmentPicker;


+ (AssignSpyController *) create;


@end

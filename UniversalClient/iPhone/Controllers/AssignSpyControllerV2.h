//
//  AssignViewControllerV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Intelligence;
@class Spy;


@interface AssignSpyControllerV2 : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate> {
	UIPickerView *assignmentPicker;
	Intelligence *intelligence;
	Spy *spy;
	NSDictionary *assignedMission;
}


@property (nonatomic, retain) IBOutlet UIPickerView *assignmentPicker;
@property (nonatomic, retain) Intelligence *intelligence;
@property (nonatomic, retain) Spy *spy;
@property (nonatomic, retain) NSDictionary *assignedMission;


- (IBAction)cancel;
- (IBAction)save;


+ (AssignSpyControllerV2 *)create;


@end

//
//  PickColonyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickColonyDelegate

- (void)colonySelected:(NSString *)colonyId;

@end


@interface PickColonyController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *colonyPicker;
	NSMutableArray *colonies;
	id<PickColonyDelegate> delegate;
}


@property (nonatomic, retain) IBOutlet UIPickerView *colonyPicker;
@property (nonatomic, retain) IBOutlet NSMutableArray *colonies;
@property (nonatomic, assign) IBOutlet id<PickColonyDelegate> delegate;


- (IBAction)cancel;
- (IBAction)save;


+ (PickColonyController *)create;


@end

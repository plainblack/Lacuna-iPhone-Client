//
//  PickNumericValue.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickNumericValueControllerDelegate

- (void)newNumericValue:(NSNumber *)value;

@end



@interface PickNumericValueController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	UILabel *titleLabel;
	UIPickerView *numberPicker;
	id<PickNumericValueControllerDelegate> delegate;
}


@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *numberPicker;
@property (nonatomic, assign) id<PickNumericValueControllerDelegate> delegate;


-(IBAction) save;
-(IBAction) cancel;
-(void) setValue:(NSNumber *)value;


+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate;


@end

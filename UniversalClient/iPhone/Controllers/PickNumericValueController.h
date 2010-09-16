//
//  PickNumericValue.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickNumericValueControllerDelegate

- (void)newNumericValue:(NSDecimalNumber *)value;

@end



@interface PickNumericValueController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	UILabel *titleLabel;
	UIButton *maxButton;
	UIPickerView *numberPicker;
	id<PickNumericValueControllerDelegate> delegate;
	NSDecimalNumber *maxValue;
	NSInteger numDigits;
	NSInteger leftMostDigit;
}


@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *maxButton;
@property (nonatomic, retain) IBOutlet UIPickerView *numberPicker;
@property (nonatomic, assign) id<PickNumericValueControllerDelegate> delegate;
@property (nonatomic, retain) NSDecimalNumber *maxValue;


-(IBAction) save;
-(IBAction) cancel;
-(IBAction) max;
-(void) setValue:(NSDecimalNumber *)value;


+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate maxValue:(NSDecimalNumber *)maxValue;


@end

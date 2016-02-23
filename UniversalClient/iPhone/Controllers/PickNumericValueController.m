//
//  PickNumericValue.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PickNumericValueController.h"
#import "LEMacros.h"
#import "Util.h"


@implementation PickNumericValueController


@synthesize titleLabel;
@synthesize maxButton;
@synthesize numberPicker;
@synthesize delegate;
@synthesize maxValue;
@synthesize hideZero;
@synthesize showTenths;


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	if (self.maxValue) {
		maxButton.hidden = NO;
	} else {
		maxButton.hidden = YES;
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	self.titleLabel = nil;
	self.maxButton = nil;
	self.numberPicker = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.titleLabel = nil;
	self.maxButton = nil;
	self.numberPicker = nil;
	self.delegate = nil;
	self.maxValue = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return self->numDigits;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		if (self.hideZero) {
			return self->leftMostDigit;
		} else {
			return self->leftMostDigit+1;
		}

	} else if ((component == self->numDigits-2) && self.showTenths) {
		return 1;
	} else {
		if (self.hideZero) {
			return 9;
		} else {
			return 10;
		}
	}
}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0 && self.hideZero) {
		return [NSString stringWithFormat:@"%li",
				row+1];
	} else if ((component == self->numDigits-2) && self.showTenths) {
		return @".";
	} else {
		return [NSString stringWithFormat:@"%li", (long)row];
	}
}


#pragma mark -
#pragma mark Instance Methods

-(IBAction) save {
	NSMutableString *valueAsString = [NSMutableString stringWithCapacity:self->numDigits];
	
	for (int index=0; index < self->numDigits; index++) {
		if (self.showTenths && index == self->numDigits-2) {
			[valueAsString appendFormat:@"."];
		} else {
			if (self.hideZero) {
				[valueAsString appendFormat:@"%li", [self.numberPicker selectedRowInComponent:index]+1];
			} else {
				[valueAsString appendFormat:@"%li", (long)[self.numberPicker selectedRowInComponent:index]];
			}
		}
	}
	[self.delegate newNumericValue:[NSDecimalNumber decimalNumberWithString:valueAsString]];
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction) cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction) max {
	[self setValue:self.maxValue];
}


-(void) setValue:(NSDecimalNumber *)value {
	NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
	value = [value decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	NSString *valueAsString = [value stringValue];
	NSInteger valueNumDigits = [valueAsString length];
	NSInteger diff = (self->numDigits - valueNumDigits);

	for (int index=0; index < valueNumDigits; index++) {
		if (index == valueNumDigits-1) {
			if (self.hideZero) {
				[self.numberPicker selectRow:_intv([valueAsString substringFromIndex:index])-1 inComponent:(index+diff) animated:YES];
			} else {
				[self.numberPicker selectRow:_intv([valueAsString substringFromIndex:index]) inComponent:(index+diff) animated:YES];
			}

		} else {
			NSRange range = NSMakeRange(index, 1);
			NSInteger digit = _intv([valueAsString substringWithRange:range]);
			if (self.hideZero) {
				[self.numberPicker selectRow:digit-1 inComponent:(index+diff) animated:YES];
			} else {
				[self.numberPicker selectRow:digit inComponent:(index+diff) animated:YES];
			}
		}
	}
}


#pragma mark -
#pragma mark Class Methods

+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate maxValue:(NSDecimalNumber *)maxValue hidesZero:(BOOL)hidesZero showTenths:(BOOL)showTenths {
	PickNumericValueController *pickNumericValueController = [[[PickNumericValueController alloc] initWithNibName:@"PickNumericValueController" bundle:nil] autorelease];
	pickNumericValueController.delegate = delegate;
	if (!maxValue) {
		maxValue = [NSDecimalNumber decimalNumberWithString:@"999999"];
	}
	NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
	pickNumericValueController.hideZero = hidesZero;
	pickNumericValueController.showTenths = showTenths;
	pickNumericValueController.maxValue = [maxValue decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	NSString *maxValueAsString = [pickNumericValueController.maxValue stringValue];
	pickNumericValueController->numDigits = [maxValueAsString length];
	if (pickNumericValueController.showTenths) {
		pickNumericValueController->numDigits += 2;
	}
	pickNumericValueController->leftMostDigit = _intv([maxValueAsString substringToIndex:1]);

	return pickNumericValueController;
}


@end

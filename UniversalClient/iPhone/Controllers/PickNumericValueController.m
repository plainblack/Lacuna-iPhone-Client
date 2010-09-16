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
		return self->leftMostDigit+1;
	} else {
		return 10;
	}
}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i", row];
}


#pragma mark -
#pragma mark Instance Methods

-(IBAction) save {
	NSMutableString *valueAsString = [NSMutableString stringWithCapacity:self->numDigits];
	
	for (int index=0; index < self->numDigits; index++) {
		[valueAsString appendFormat:@"%i", [self.numberPicker selectedRowInComponent:index]];
	}
	[self.delegate newNumericValue:[NSDecimalNumber decimalNumberWithString:valueAsString]];
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction) cancel {
	[self dismissModalViewControllerAnimated:YES];
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
			[self.numberPicker selectRow:_intv([valueAsString substringFromIndex:index]) inComponent:(index+diff) animated:YES];
		} else {
			NSRange range = NSMakeRange(index, 1);
			NSInteger digit = _intv([valueAsString substringWithRange:range]);
			[self.numberPicker selectRow:digit inComponent:(index+diff) animated:YES];
		}
	}
}


#pragma mark -
#pragma mark Class Methods

+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate maxValue:(NSDecimalNumber *)maxValue {
	PickNumericValueController *pickNumericValueController = [[[PickNumericValueController alloc] initWithNibName:@"PickNumericValueController" bundle:nil] autorelease];
	pickNumericValueController.delegate = delegate;
	if (maxValue) {
		NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
		pickNumericValueController.maxValue = [maxValue decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
		NSString *maxValueAsString = [pickNumericValueController.maxValue stringValue];
		pickNumericValueController->numDigits = [maxValueAsString length];
		pickNumericValueController->leftMostDigit = _intv([maxValueAsString substringToIndex:1]);
	} else {
		pickNumericValueController.maxValue = [NSDecimalNumber decimalNumberWithString:@"999999"];
	}

	return pickNumericValueController;
}


@end

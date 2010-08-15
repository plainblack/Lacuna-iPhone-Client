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
@synthesize numberPicker;
@synthesize delegate;
@synthesize maxValue;


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = CELL_BACKGROUND_COLOR;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	self.titleLabel = nil;
	self.numberPicker = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.delegate = nil;
	self.maxValue = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 6;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 10;
}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i", row];
}


#pragma mark -
#pragma mark Instance Methods

-(IBAction) save {
	NSInteger value = 0;
	value += [self.numberPicker selectedRowInComponent:0] * 100000;
	value += [self.numberPicker selectedRowInComponent:1] * 10000;
	value += [self.numberPicker selectedRowInComponent:2] * 1000;
	value += [self.numberPicker selectedRowInComponent:3] * 100;
	value += [self.numberPicker selectedRowInComponent:4] * 10;
	value += [self.numberPicker selectedRowInComponent:5];
	[self.delegate newNumericValue:[Util decimalFromInt:value]];
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction) cancel {
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction) max {
	[self setValue:self.maxValue];
}


-(void) setValue:(NSDecimalNumber *)value {
	NSInteger tmp = [value intValue];
	
	[self.numberPicker selectRow:(tmp/100000)%10 inComponent:0 animated:YES];
	[self.numberPicker selectRow:(tmp/10000)%10 inComponent:1 animated:YES];
	[self.numberPicker selectRow:(tmp/1000)%10 inComponent:2 animated:YES];
	[self.numberPicker selectRow:(tmp/100)%10 inComponent:3 animated:YES];
	[self.numberPicker selectRow:(tmp/10)%10 inComponent:4 animated:YES];
	[self.numberPicker selectRow:tmp%10 inComponent:5 animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate maxValue:(NSDecimalNumber *)maxValue {
	PickNumericValueController *pickNumericValueController = [[[PickNumericValueController alloc] initWithNibName:@"PickNumericValueController" bundle:nil] autorelease];
	pickNumericValueController.delegate = delegate;
	pickNumericValueController.maxValue = maxValue;
	return pickNumericValueController;
}


@end

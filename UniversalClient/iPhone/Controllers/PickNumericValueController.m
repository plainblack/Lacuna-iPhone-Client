//
//  PickNumericValue.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PickNumericValueController.h"


@implementation PickNumericValueController


@synthesize titleLabel;
@synthesize numberPicker;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
	[self.delegate newNumericValue:[NSNumber numberWithInt:value]];
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction) cancel {
	[self dismissModalViewControllerAnimated:YES];
}


-(void) setValue:(NSNumber *)value {
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

+(PickNumericValueController *) createWithDelegate:(id<PickNumericValueControllerDelegate>)delegate {
	PickNumericValueController *pickNumericValueController = [[[PickNumericValueController alloc] initWithNibName:@"PickNumericValueController" bundle:nil] autorelease];
	pickNumericValueController.delegate = delegate;
	return pickNumericValueController;
}


@end

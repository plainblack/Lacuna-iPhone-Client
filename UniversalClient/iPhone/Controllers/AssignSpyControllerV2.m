//
//  AssignViewControllerV2.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AssignSpyControllerV2.h"
#import "LEMacros.h"
#import "Intelligence.h"
#import "Spy.h"


@implementation AssignSpyControllerV2


@synthesize assignmentPicker;
@synthesize intelligence;
@synthesize spy;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Assign Spy";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	NSInteger assignementIndex = [self.intelligence.possibleAssignments indexOfObject:self.spy.assignment];
	[self.assignmentPicker selectRow:assignementIndex inComponent:0 animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.assignmentPicker = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	self.intelligence = nil;
	self.spy = nil;
}


#pragma mark -
#pragma mark UIViewPicker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.intelligence.possibleAssignments count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.intelligence.possibleAssignments objectAtIndex:row];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	NSInteger row = [self.assignmentPicker selectedRowInComponent:0];
	NSString *assignment = [self.intelligence.possibleAssignments objectAtIndex:row];
	[self.intelligence spy:self.spy assign:assignment];
	[[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (AssignSpyControllerV2 *)create {
	AssignSpyControllerV2 *assignViewControllerV2 = [[[AssignSpyControllerV2 alloc] initWithNibName:@"AssignViewControllerV2" bundle:nil] autorelease];
	return assignViewControllerV2;
}


@end

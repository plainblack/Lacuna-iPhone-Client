//
//  PickColonyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PickColonyController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"

@implementation PickColonyController


@synthesize colonyPicker;
@synthesize colonies;
@synthesize delegate;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Colony";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    self.colonyPicker = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    self.colonyPicker = nil;
	self.colonies = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewPicker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.colonies count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[self.colonies objectAtIndex:row] objectForKey:@"name"];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)save {
	NSInteger row = [self.colonyPicker selectedRowInComponent:0];
	NSDictionary *colony = [self.colonies objectAtIndex:row];
	[self.delegate colonySelected:[Util idFromDict:colony named:@"id"]];
}


#pragma mark -
#pragma mark Class Methods

+ (PickColonyController *)create {
	PickColonyController *pickColonyController = [[[PickColonyController alloc] initWithNibName:@"PickColonyController" bundle:nil] autorelease];
	return pickColonyController;
}


@end

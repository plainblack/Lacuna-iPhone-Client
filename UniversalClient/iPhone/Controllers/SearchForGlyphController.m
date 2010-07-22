//
//  SearchForGlyphController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SearchForGlyphController.h"
#import "Archaeology.h"


@implementation SearchForGlyphController


@synthesize archaeology;
@synthesize orePicker;
@synthesize oreTypes;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search for glyph";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(search)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor clearColor];
	
	self.oreTypes = [self.archaeology getAvailableOreTypes];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.oreTypes count];
}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.oreTypes objectAtIndex:row];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.orePicker = nil;
}


- (void)dealloc {
    [super dealloc];
	self.archaeology = nil;
	self.oreTypes = nil;
}


#pragma mark --
#pragma mark Instance Methods

- (IBAction)search {
	NSString *selectedOreType = [[self.oreTypes objectAtIndex:[self.orePicker selectedRowInComponent:0]] lowercaseString];
	NSLog(@"Selected Ore Type: %@", selectedOreType);
	[self.archaeology searchForGlyph:selectedOreType];
}


#pragma mark --
#pragma mark Class Methods

+ (SearchForGlyphController *)create {
	SearchForGlyphController *searchForGlyphController = [[[SearchForGlyphController alloc] initWithNibName:@"SearchForGlyphController" bundle:nil] autorelease];
	return searchForGlyphController;
}

@end

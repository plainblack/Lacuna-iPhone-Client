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


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search Ore";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(search)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor clearColor];
	
	[self.archaeology addObserver:self forKeyPath:@"availableOreTypes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.archaeology loadAvailableOreTypes];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.archaeology removeObserver:self forKeyPath:@"availableOreTypes"];
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
	if (self.archaeology.availableOreTypes) {
		return [self.archaeology.availableOreTypes count];
	} else {
		return 1;
	}

}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (self.archaeology.availableOreTypes) {
		NSDictionary *oreTypeData = [self.archaeology.availableOreTypes objectAtIndex:row];
		return [NSString stringWithFormat:@"%@ (%@)", [oreTypeData objectForKey:@"type"], [oreTypeData objectForKey:@"amount"] ];
	} else {
		return @"Loading";
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	self.orePicker = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	self.archaeology = nil;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)search {
	NSString *selectedOreType = [[self.archaeology.availableOreTypes objectAtIndex:[self.orePicker selectedRowInComponent:0]] objectForKey:@"type"];
	[self.archaeology searchForGlyph:selectedOreType];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (SearchForGlyphController *)create {
	SearchForGlyphController *searchForGlyphController = [[[SearchForGlyphController alloc] initWithNibName:@"SearchForGlyphController" bundle:nil] autorelease];
	return searchForGlyphController;
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"availableOreTypes"]) {
		[self.orePicker reloadAllComponents];
	}
}


@end

//
//  AssembleGlyphsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AssembleGlyphsController.h"
#import "Archaeology.h"
#import "Glyph.h"


@implementation AssembleGlyphsController


@synthesize archaeology;
@synthesize glyphPicker;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search for glyph";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Assemble" style:UIBarButtonItemStylePlain target:self action:@selector(assemble)] autorelease];
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor clearColor];
	
	[self.archaeology addObserver:self forKeyPath:@"glyphs" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.archaeology loadGlyphs];
}


- (void)viewDidDisappear:(BOOL)animated {
	[self.archaeology removeObserver:self forKeyPath:@"glyphs"];
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (self.archaeology.glyphs) {
		return 4;
	} else {
		return 1;
	}
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (self.archaeology.glyphs) {
		return [self.archaeology.glyphs count];
	} else {
		return 1;
	}
}


#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (self.archaeology.glyphs) {
		Glyph *glyph = [self.archaeology.glyphs objectAtIndex:row];
		return glyph.type;
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
    [super viewDidUnload];
	self.glyphPicker = nil;
}


- (void)dealloc {
    [super dealloc];
	self.archaeology = nil;
}


#pragma mark --
#pragma mark Instance Methods

- (IBAction)assemble {
	NSMutableArray *glyphIds = [NSMutableArray arrayWithCapacity:4];
	Glyph *glyph;
	NSInteger index;
	for (int component=0; component<4; component++) {
		index = [self.glyphPicker selectedRowInComponent:component];
		if (index > 0) {
			glyph = [self.archaeology.glyphs objectAtIndex:(index-1)];
			[glyphIds addObject:glyph.id];
		}
	}
	NSLog(@"Selected Glyphs: %@", glyphIds);
	[self.archaeology assembleGlyphs:glyphIds];
}


#pragma mark --
#pragma mark Class Methods

+ (AssembleGlyphsController *)create {
	AssembleGlyphsController *assembleGlyphsController = [[[AssembleGlyphsController alloc] initWithNibName:@"AssembleGlyphsController" bundle:nil] autorelease];
	return assembleGlyphsController;
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"glyphs"]) {
		[self.glyphPicker reloadAllComponents];
	}
}


@end

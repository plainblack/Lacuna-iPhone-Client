//
//  AssembleGlyphsControllerV2.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AssembleGlyphsControllerV2.h"
#import "Archaeology.h"
#import "Glyph.h"
#import "LEMacros.h"
#import "SelectGlyphController.h"


@implementation AssembleGlyphsControllerV2


@synthesize archaeology;
@synthesize selectedGlyphs;
@synthesize glyphSelect1;
@synthesize glyphDelete1;
@synthesize glyphSelect2;
@synthesize glyphDelete2;
@synthesize glyphSelect3;
@synthesize glyphDelete3;
@synthesize glyphSelect4;
@synthesize glyphDelete4;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!self.selectedGlyphs) {
		self.selectedGlyphs = _array([NSNull null], [NSNull null], [NSNull null], [NSNull null]);
	}
	
	self.navigationItem.title = @"Assemble Glyphs";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor clearColor];
	
	[self updateGlyph:0];
	[self updateGlyph:1];
	[self updateGlyph:2];
	[self updateGlyph:3];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	self.glyphSelect1 = nil;
	self.glyphDelete1 = nil;
	self.glyphSelect2 = nil;
	self.glyphDelete2 = nil;
	self.glyphSelect3 = nil;
	self.glyphDelete3 = nil;
	self.glyphSelect4 = nil;
	self.glyphDelete4 = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.archaeology = nil;
	self.selectedGlyphs = nil;
	self.glyphSelect1 = nil;
	self.glyphDelete1 = nil;
	self.glyphSelect2 = nil;
	self.glyphDelete2 = nil;
	self.glyphSelect3 = nil;
	self.glyphDelete3 = nil;
	self.glyphSelect4 = nil;
	self.glyphDelete4 = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)combine {
	NSMutableArray *glyphIds = [NSMutableArray arrayWithCapacity:4];
	for (Glyph *glyph in self.selectedGlyphs) {
		if (isNotNull(glyph)) {
			[glyphIds addObject:glyph.id];
		}
	}
	
	if ([glyphIds count] > 0) {
		self.archaeology.delegate = self;
		[self.archaeology assembleGlyphs:glyphIds];
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Failed" message: @"You must select at least one glyph to combine" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}

}


- (IBAction)deleteGlyph:(id)sender {
	NSInteger glyphIndex = 0;

	if (sender == self.glyphDelete1) {
		glyphIndex = 0;
	} else if (sender == self.glyphDelete2) {
		glyphIndex = 1;
	} else if (sender == self.glyphDelete3) {
		glyphIndex = 2;
	} else if (sender == self.glyphDelete4) {
		glyphIndex = 3;
	}

	[self.selectedGlyphs replaceObjectAtIndex:glyphIndex withObject:[NSNull null]];
	[self updateGlyph:glyphIndex];
}


- (IBAction)selectGlyph:(id)sender {
	if (sender == self.glyphSelect1) {
		self->selectedGlyphIndex = 0;
	} else if (sender == self.glyphSelect2) {
		self->selectedGlyphIndex = 1;
	} else if (sender == self.glyphSelect3) {
		self->selectedGlyphIndex = 2;
	} else if (sender == self.glyphSelect4) {
		self->selectedGlyphIndex = 3;
	}
	
	SelectGlyphController *selectGlyphController = [SelectGlyphController create];
	selectGlyphController.delegate = self;
	selectGlyphController.archaeology = self.archaeology;
	selectGlyphController.filterGlyphs = self.selectedGlyphs;
	[self.navigationController pushViewController:selectGlyphController animated:YES];
}


- (void)updateGlyph:(NSInteger)glyphIndex {
	Glyph *glyph = [self.selectedGlyphs objectAtIndex:glyphIndex];
	switch (glyphIndex) {
		case 0:
			if (isNotNull(glyph)) {
				self.glyphDelete1.hidden = NO;
				[self.glyphSelect1 setImage:[UIImage imageNamed:glyph.imageName] forState:UIControlStateNormal];
			} else {
				self.glyphDelete1.hidden = YES;
				[self.glyphSelect1 setImage:nil forState:UIControlStateNormal];
			}
			break;
		case 1:
			if (isNotNull(glyph)) {
				self.glyphDelete2.hidden = NO;
				[self.glyphSelect2 setImage:[UIImage imageNamed:glyph.imageName] forState:UIControlStateNormal];
			} else {
				self.glyphDelete2.hidden = YES;
				[self.glyphSelect2 setImage:nil forState:UIControlStateNormal];
			}
			break;
		case 2:
			if (isNotNull(glyph)) {
				self.glyphDelete3.hidden = NO;
				[self.glyphSelect3 setImage:[UIImage imageNamed:glyph.imageName] forState:UIControlStateNormal];
			} else {
				self.glyphDelete3.hidden = YES;
				[self.glyphSelect3 setImage:nil forState:UIControlStateNormal];
			}
			break;
		case 3:
			if (isNotNull(glyph)) {
				self.glyphDelete4.hidden = NO;
				[self.glyphSelect4 setImage:[UIImage imageNamed:glyph.imageName] forState:UIControlStateNormal];
			} else {
				self.glyphDelete4.hidden = YES;
				[self.glyphSelect4 setImage:nil forState:UIControlStateNormal];
			}
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Archaeology Delegate Methods

- (void) assembleyComplete:(NSString *)itemName {
	[archaeology loadGlyphs];
	
	UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Glyphs Assembled" message:[NSString stringWithFormat:@"You assembled a %@ plan.", itemName] preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
						 { [av dismissViewControllerAnimated:YES completion:nil]; }];
	[av addAction: ok];
	[self presentViewController:av animated:YES completion:nil];
	[self.selectedGlyphs replaceObjectAtIndex:0 withObject:[NSNull null]];
	[self.selectedGlyphs replaceObjectAtIndex:1 withObject:[NSNull null]];
	[self.selectedGlyphs replaceObjectAtIndex:2 withObject:[NSNull null]];
	[self.selectedGlyphs replaceObjectAtIndex:3 withObject:[NSNull null]];
	[self updateGlyph:0];
	[self updateGlyph:1];
	[self updateGlyph:2];
	[self updateGlyph:3];
}


- (void) assembleyFailed:(NSString *)reason {
	UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Failed" message:reason preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
						 { [av dismissViewControllerAnimated:YES completion:nil]; }];
	[av addAction: ok];
	[self presentViewController:av animated:YES completion:nil];
}


#pragma mark -
#pragma mark SelectGlyphControllerDelegate Methods

- (void)glyphSelected:(Glyph *)glyph {
	[self.selectedGlyphs replaceObjectAtIndex:self->selectedGlyphIndex withObject:glyph];
	[self updateGlyph:self->selectedGlyphIndex];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (AssembleGlyphsControllerV2 *)create {
	AssembleGlyphsControllerV2 *assembleGlyphsController = [[[AssembleGlyphsControllerV2 alloc] initWithNibName:@"AssembleGlyphsControllerV2" bundle:nil] autorelease];
	return assembleGlyphsController;
}


@end

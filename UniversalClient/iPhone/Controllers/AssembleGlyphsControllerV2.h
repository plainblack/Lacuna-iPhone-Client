//
//  AssembleGlyphsControllerV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Archaeology.h"
#import "SelectGlyphController.h"


@class Archaeology;


@interface AssembleGlyphsControllerV2 : UIViewController <ArchaeologyDelegate, SelectGlyphControllerDelegate> {
	Archaeology *archaeology;
	NSMutableArray *selectedGlyphs;
	UIButton *glyphSelect1;
	UIButton *glyphDelete1;
	UIButton *glyphSelect2;
	UIButton *glyphDelete2;
	UIButton *glyphSelect3;
	UIButton *glyphDelete3;
	UIButton *glyphSelect4;
	UIButton *glyphDelete4;
	NSInteger selectedGlyphIndex;
}


@property (nonatomic,retain) Archaeology *archaeology;
@property (nonatomic,retain) NSMutableArray *selectedGlyphs;
@property (nonatomic,retain) IBOutlet UIButton *glyphSelect1;
@property (nonatomic,retain) IBOutlet UIButton *glyphDelete1;
@property (nonatomic,retain) IBOutlet UIButton *glyphSelect2;
@property (nonatomic,retain) IBOutlet UIButton *glyphDelete2;
@property (nonatomic,retain) IBOutlet UIButton *glyphSelect3;
@property (nonatomic,retain) IBOutlet UIButton *glyphDelete3;
@property (nonatomic,retain) IBOutlet UIButton *glyphSelect4;
@property (nonatomic,retain) IBOutlet UIButton *glyphDelete4;


- (IBAction)combine;
- (IBAction)deleteGlyph:(id)sender;
- (IBAction)selectGlyph:(id)sender;
- (void)updateGlyph:(NSInteger)glyphIndex;


+ (AssembleGlyphsControllerV2 *)create;


@end

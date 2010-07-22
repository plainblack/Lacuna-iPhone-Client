//
//  AssembleGlyphsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Archaeology;


@interface AssembleGlyphsController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	Archaeology *archaeology;
	UIPickerView *glyphPicker;
}


@property (nonatomic, retain) Archaeology *archaeology;
@property (nonatomic, retain) IBOutlet UIPickerView *glyphPicker;


- (IBAction)assemble;


+ (AssembleGlyphsController *)create;


@end

//
//  SearchForGlyphController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Archaeology;


@interface SearchForGlyphController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	Archaeology *archaeology;
	UIPickerView *orePicker;
	NSArray *oreTypes;
}


@property (nonatomic, retain) Archaeology *archaeology;
@property (nonatomic, retain) IBOutlet UIPickerView *orePicker;
@property (nonatomic, retain) NSArray *oreTypes;


- (IBAction)search;


+ (SearchForGlyphController *)create;


@end

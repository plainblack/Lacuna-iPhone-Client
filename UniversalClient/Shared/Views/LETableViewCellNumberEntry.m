//
//  LETableViewCellNumberEntry.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellNumberEntry.h"
#import "LEMacros.h"
#import "Util.h"
#import "PickNumericValueController.h"


@implementation LETableViewCellNumberEntry


@synthesize label;
@synthesize numberButton;
@synthesize viewController;
@synthesize numericValue;
@synthesize maxValue;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	self.label = nil;
	self.numberButton = nil;
	self.viewController = nil;
	self.numericValue = nil;
	self.maxValue = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PickNumericValueController Methods

- (void)newNumericValue:(NSDecimalNumber *)value {
	if ([self.maxValue compare:value] == NSOrderedAscending) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Amount Invalid" message:[NSString stringWithFormat:@"You entered %@ which is above the maximum amount of %@.", value, self.maxValue] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		value = self.maxValue;
	}
	[self setNumericValue:value];
	[self.numberButton setTitle:[value stringValue] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)editNumericValue {
    NSLog(@"maxValue: %@", self.maxValue);
	PickNumericValueController *pickNumericValueController = [PickNumericValueController createWithDelegate:self maxValue:self.maxValue hidesZero:NO showTenths:NO];
	[self.viewController presentViewController:pickNumericValueController animated:YES completion:nil];
	[pickNumericValueController setValue:self.numericValue];
	pickNumericValueController.titleLabel.text = self.label.text;
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self editNumericValue];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellNumberEntry *)getCellForTableView:(UITableView *)tableView viewController:(UIViewController *)viewController maxValue:(NSDecimalNumber *)inMaxValue {
    static NSString *CellIdentifier = @"NumberEntryCell";
	
	LETableViewCellNumberEntry *cell = (LETableViewCellNumberEntry *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellNumberEntry alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.maxValue = inMaxValue;
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = NSTextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.label];
		cell.numberButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cell.numberButton.frame = CGRectMake(105, 6, 210, 32);
		cell.numberButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.numberButton addTarget:cell action:@selector(editNumericValue) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:cell.numberButton];
		
		//Set Font stuff
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.numberButton.titleLabel.font = TEXT_ENTRY_FONT;
		cell.numberButton.titleLabel.textColor = TEXT_ENTRY_COLOR;
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(callTapped:)] autorelease];
		[cell.contentView addGestureRecognizer:tapRecognizer];
	}

	cell.viewController = viewController;
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

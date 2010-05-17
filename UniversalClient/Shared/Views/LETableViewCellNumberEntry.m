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
	[numericValue release];
    [super dealloc];
}


#pragma mark -
#pragma mark PickNumericValueController Methods

- (void)newNumericValue:(NSNumber *)value {
	NSLog(@"newNumericValue: %@", value);
	[numericValue release];
	numericValue = value;
	[numericValue retain];
	[self.numberButton setTitle:[value stringValue] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setNumericValue:(NSNumber *)value {
	[numericValue release];
	numericValue = value;
	[numericValue retain];
	[self.numberButton setTitle:[value stringValue] forState:UIControlStateNormal];
}


- (IBAction)editNumericValue {
	PickNumericValueController *pickNumericValueController = [PickNumericValueController createWithDelegate:self];
	[self.viewController presentModalViewController:pickNumericValueController animated:YES];
	[pickNumericValueController setValue:numericValue];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellNumberEntry *)getCellForTableView:(UITableView *)tableView viewController:(UIViewController *)viewController {
    static NSString *CellIdentifier = @"NumberEntryCell";
	
	LETableViewCellNumberEntry *cell = (LETableViewCellNumberEntry *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellNumberEntry alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textAlignment = UITextAlignmentRight;
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
	}

	cell.viewController = viewController;
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return tableView.rowHeight;
}


@end

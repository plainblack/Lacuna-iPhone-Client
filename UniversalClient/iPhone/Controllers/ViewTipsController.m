//
//  ViewTipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewTipsController.h"
#import	<QuartzCore/QuartzCore.h>
#import "LEMacros.h"
#import "Session.h"


@implementation ViewTipsController


@synthesize toolbar;
@synthesize tipLabel;
@synthesize tipTextView;
@synthesize tipAlertSwitch;
@synthesize tips;


- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.tipTextView.backgroundColor = CELL_BACKGROUND_COLOR;
	self.tipTextView.textColor = TEXT_COLOR;
	self.tipTextView.font = TEXT_FONT;
	self.tipTextView.layer.borderWidth = 1;
	self.tipTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.tipTextView.layer.cornerRadius = 8;
	
	self->currentTipIdx = 0;
		
	self.tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 22.0)] autorelease];
	self.tipLabel.font = TEXT_FONT;
	self.tipLabel.textColor = TEXT_COLOR;
	self.tipLabel.backgroundColor = [UIColor clearColor];
	self.tipLabel.text = @"Tips";
	UIBarButtonItem *tipsBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.tipLabel] autorelease];
	UIBarButtonItem *flexable = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem	*prevButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStylePlain target:self action:@selector(previousTip)] autorelease];
	UIBarButtonItem	*nextButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStylePlain target:self action:@selector(nextTip)] autorelease];
	[self.toolbar setItems:_array(prevButtonItem, flexable, tipsBarButtonItem, flexable, nextButtonItem)];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	self.tipAlertSwitch.on = ![userDefaults boolForKey:@"HideTipsAlert"];

	Session *session = [Session sharedInstance];
	[session readItemDescriptions];
	self.tips = [session.itemDescriptions objectForKey:@"tips"];
	
	self.tipLabel.text = [NSString stringWithFormat:@"Tip %i/%lu", self->currentTipIdx+1, (unsigned long)[self.tips count]];
	self.tipTextView.text = [self.tips objectAtIndex:self->currentTipIdx];
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
    [super viewDidUnload];
	self.toolbar = nil;
	self.tipLabel = nil;
	self.tipTextView = nil;
	self.tipAlertSwitch = nil;
	self.tips = nil;
}


- (void)dealloc {
    [super dealloc];
	self.toolbar = nil;
	self.tipLabel = nil;
	self.tipTextView = nil;
	self.tipAlertSwitch = nil;
	self.tips = nil;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)previousTip {
	self->currentTipIdx--;
	if (self->currentTipIdx < 0) {
		self->currentTipIdx = [self.tips count]-1;
	}
	self.tipLabel.text = [NSString stringWithFormat:@"Tip %i/%lu", self->currentTipIdx+1, (unsigned long)[self.tips count]];
	self.tipTextView.text = [self.tips objectAtIndex:self->currentTipIdx];
}


- (IBAction)nextTip {
	self->currentTipIdx++;
	if (self->currentTipIdx >= [self.tips count]) {
		self->currentTipIdx = 0;
	}
	self.tipLabel.text = [NSString stringWithFormat:@"Tip %i/%lu", self->currentTipIdx+1, (unsigned long)[self.tips count]];
	self.tipTextView.text = [self.tips objectAtIndex:self->currentTipIdx];
}


- (IBAction)toggleTipAlert {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:!self.tipAlertSwitch.on forKey:@"HideTipsAlert"];
}


@end

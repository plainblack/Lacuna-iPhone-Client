//
//  ViewTipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewTipsController.h"
#import "LEMacros.h"
#import "Session.h"


@implementation ViewTipsController


@synthesize toolbar;
@synthesize tipTextView;
@synthesize tips;


- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.tipTextView.backgroundColor = CELL_BACKGROUND_COLOR;
	self.tipTextView.textColor = TEXT_COLOR;
	self.tipTextView.font = TEXT_FONT;
	
	self->currentTipIdx = 0;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];
	[session readItemDescriptions];
	self.tips = [session.itemDescriptions objectForKey:@"tips"];
	NSLog(@"Tips: %@", tips);
	
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
	self.tipTextView = nil;
	self.tips = nil;
}


- (void)dealloc {
    [super dealloc];
	self.toolbar = nil;
	self.tipTextView = nil;
	self.tips = nil;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)previousTip {
	self->currentTipIdx--;
	self.tipTextView.text = [self.tips objectAtIndex:self->currentTipIdx];
}


- (IBAction)nextTip {
	self->currentTipIdx++;
	self.tipTextView.text = [self.tips objectAtIndex:self->currentTipIdx];
}


@end

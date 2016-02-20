//
//  ViewStatsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewStatsController.h"
#import "Session.h"


@implementation ViewStatsController


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Stats";
	if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)] autorelease];
	}
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
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


@end

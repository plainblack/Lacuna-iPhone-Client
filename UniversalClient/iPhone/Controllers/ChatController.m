//
//  ChatController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ChatController.h"
#import "LEMacros.h"
#import "Session.h"


@implementation ChatController


@synthesize toolbar;
@synthesize webView;
@synthesize activityIndicatorView;
@synthesize previousButton;
@synthesize nextButton;
@synthesize refreshButton;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.webView.hidden = YES;
	
	Session *session = [Session sharedInstance];
	NSURL *baseUrl = [NSURL URLWithString:session.serverUri];
	NSURL *chatUrl = [NSURL URLWithString:[NSString stringWithFormat:@"/chat?session_id=%@", session.sessionId] relativeToURL:baseUrl];
	[self.webView loadRequest:[NSURLRequest requestWithURL:chatUrl]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:YES];
	
	if (self.webView.isLoading) {
		[self.webView stopLoading];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	self.toolbar = nil;
	self.webView = nil;
	self.activityIndicatorView = nil;
	self.previousButton = nil;
	self.nextButton = nil;
	self.refreshButton = nil;
    [super viewDidUnload];
} 


- (void)dealloc {
	self.toolbar = nil;
	self.webView = nil;
	self.activityIndicatorView = nil;
	self.previousButton = nil;
	self.nextButton = nil;
	self.refreshButton = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.previousButton.enabled = YES;
	self.nextButton.enabled = self.webView.canGoForward;
	self.refreshButton.enabled = NO;
	self.webView.hidden = YES;
	[self.activityIndicatorView startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.previousButton.enabled = self.webView.canGoBack;
	self.nextButton.enabled = self.webView.canGoForward;
	self.refreshButton.enabled = YES;
	[self.activityIndicatorView stopAnimating];
	self.webView.hidden = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self.previousButton.enabled = self.webView.canGoBack;
	self.nextButton.enabled = self.webView.canGoForward;
	self.refreshButton.enabled = YES;
	[self.activityIndicatorView stopAnimating];
	self.webView.hidden = NO;
}


@end

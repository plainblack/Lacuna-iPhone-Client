//
//  WebPageController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "WebPageController.h"
#import "LEMacros.h"


@implementation WebPageController


@synthesize toolbar;
@synthesize webView;
@synthesize activityIndicatorView;
@synthesize previousButton;
@synthesize nextButton;
@synthesize refreshButton;
@synthesize urlToLoad;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.webView.hidden = YES;
	//self.toolbar.tintColor = TINT_COLOR;
	
	if (self.urlToLoad) {
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]]];
		self.urlToLoad = nil;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
	self.urlToLoad = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)close {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)goToUrl:(NSString *)url {
	NSLog(@"WebView: %@, URL: %@", self.webView, url);
	if (self.webView) {
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	} else {
		self.urlToLoad = url;
	}

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


#pragma mark -
#pragma mark Class Methods

+(WebPageController *) create {
	WebPageController *webPageController = [[[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil] autorelease];
	return webPageController;
}


@end

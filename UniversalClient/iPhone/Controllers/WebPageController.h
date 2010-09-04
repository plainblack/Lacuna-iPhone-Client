//
//  WebPageController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebPageController : UIViewController <UIWebViewDelegate> {
	UIToolbar *toolbar;
	UIWebView *webView;
	UIActivityIndicatorView *activityIndicatorView;
	UIBarButtonItem *previousButton;
	UIBarButtonItem *nextButton;
	UIBarButtonItem *refreshButton;
	NSString *urlToLoad;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *previousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) NSString *urlToLoad;


- (IBAction)close;
- (void)goToUrl:(NSString *)url;


+ (WebPageController *)create;


@end

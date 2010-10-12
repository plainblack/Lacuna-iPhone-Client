//
//  ServerAnnouncementController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServerAnnouncementController : UIViewController <UIWebViewDelegate> {
	UIToolbar *toolbar;
	UIWebView *webView;
	UIActivityIndicatorView *activityIndicatorView;
	UIBarButtonItem *previousButton;
	UIBarButtonItem *nextButton;
	UIBarButtonItem *refreshButton;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *previousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;


@end

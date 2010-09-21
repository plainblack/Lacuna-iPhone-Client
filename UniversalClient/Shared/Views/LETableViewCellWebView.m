//
//  LETableViewCellWebView.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellWebView.h"
#import "LEMacros.h"
#import "Util.h"

#define MIN_HEIGHT 44


@implementation LETableViewCellWebView


@synthesize webView;
@synthesize height;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self->loadingContent = NO;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	self.webView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setContent:(NSString *)content {
	self->loadingContent = YES;
	NSString *htmlString;
	if (isNotNull(content)) {
		NSRegularExpression *widthImageRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{(build|essentia)\\}"
																						 options:NSRegularExpressionCaseInsensitive
																						   error:nil];
		NSRegularExpression *heightImageRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{(energy|food|happiness|ore|plots|time|waste|water)\\}"
																						  options:NSRegularExpressionCaseInsensitive
																							error:nil];
		NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:@"\\[(.*)\\]"
																				   options:NSRegularExpressionCaseInsensitive
																					 error:nil];
		NSRegularExpression *boldRegex = [NSRegularExpression regularExpressionWithPattern:@"\\*(.*)\\*"
																				   options:NSRegularExpressionCaseInsensitive
																					 error:nil];
		NSRegularExpression *empireProfileRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{Empire\\s(\\d+)\\s(.*?)\\}"
																							options:NSRegularExpressionCaseInsensitive
																							  error:nil];
		NSRegularExpression *newlineRegex = [NSRegularExpression regularExpressionWithPattern:@"\\n"
																					  options:NSRegularExpressionCaseInsensitive
																						error:nil];
		self->loadingContent = YES;
		NSMutableString *mutableString = [content mutableCopy];
		[widthImageRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<img src=\"assets/iphone ui/$1.png\" width=\"22\" />"];
		[heightImageRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<img src=\"assets/iphone ui/$1.png\" height=\"22\" />"];
		[linkRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"$1\">$1</a>"];
		[boldRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<b>$1</b>"];
		[empireProfileRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"empire://$1\">$2</a>"];
		[newlineRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<br />"];
		htmlString = [NSString stringWithFormat:@"<html><head><style>a:link {color:#FFC000;}</style></head><body style=\"background-color:transparent; color: #FFF; width: %f; font-family: sans-serif; font-size: 14px;\">%@</body></html>", self.webView.frame.size.width-20, mutableString];
		[mutableString release];
	} else {
		htmlString = [NSString stringWithFormat:@"<html><head><style>a:link {color:#FFC000;}</style></head><body style=\"background-color:transparent; color: #FFF; width: %f;\"></body></html>", self.webView.frame.size.width-20];
	}

	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[self.webView loadHTMLString:htmlString baseURL:baseURL];
}


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (!self->loadingContent) {
		NSURL *url = [request URL];
		if ([url.scheme isEqualToString:@"empire"]) {
			[self.delegate showEmpireProfile:url.host];
		} else {
			NSString *urlAsString = [[request URL] absoluteString];
			if ([[urlAsString substringToIndex:4] isEqualToString:@"http"]) {
				[self.delegate showWebPage:urlAsString];
			}
		}
	}
	return self->loadingContent;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self->loadingContent = NO;
    NSString *output = [self.webView stringByEvaluatingJavaScriptFromString:@"document.height;"];
	NSInteger pageHeight = _intv(output);
	self.height = MAX(MIN_HEIGHT, pageHeight + 10);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self->loadingContent = NO;
	NSLog(@"Load Error: %@", error);
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellWebView *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"WebViewCell";
	
	LETableViewCellWebView *cell = (LETableViewCellWebView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellWebView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.height = MIN_HEIGHT;
		
		cell.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(5, 0, 300, 34)] autorelease];
		cell.webView.backgroundColor = [UIColor clearColor];
		cell.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cell.webView.opaque = NO;
		cell.webView.delegate = cell;
		
		for (id subview in cell.webView.subviews) {
			if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
				((UIScrollView *)subview).scrollEnabled = NO;
			}
		}
		
		[cell.contentView addSubview:cell.webView];
	}
	
	return cell;
}


@end

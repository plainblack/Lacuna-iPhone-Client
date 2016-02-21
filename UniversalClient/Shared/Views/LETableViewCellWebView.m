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
@synthesize origContent;


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
    self.origContent = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setContent:(NSString *)content {
    if (![self.origContent isEqualToString:content]) {
        self.origContent = content;
        self->loadingContent = YES;
        self.height = MIN_HEIGHT;
        NSString *htmlString;
        if (isNotNull(self.origContent)) {
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
            NSRegularExpression *empireProfileRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{Empire\\s(-?\\d+)\\s(.*?)\\}"
                                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                                  error:nil];
            NSRegularExpression *allianceProfileRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{Alliance\\s(-?\\d+)\\s(.*?)\\}"
                                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                                    error:nil];
            NSRegularExpression *myPlanetRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{Planet\\s(-?\\d+)\\s(.*?)\\}"
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:nil];
            NSRegularExpression *starmapRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{Starmap\\s(-?\\d+)\\s(-?\\d+)\\s(.*?)\\}"
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:nil];
            NSRegularExpression *voteYesRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{VoteYes\\s(-?\\d+)\\s(-?\\d+)\\s(-?\\d+)\\}"
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:nil];
            NSRegularExpression *voteNoRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{VoteNo\\s(-?\\d+)\\s(-?\\d+)\\s(-?\\d+)\\}"
                                                                                         options:NSRegularExpressionCaseInsensitive
                                                                                           error:nil];
            NSRegularExpression *newlineRegex = [NSRegularExpression regularExpressionWithPattern:@"\\n"
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:nil];
            self->loadingContent = YES;
            NSMutableString *mutableString = [self.origContent mutableCopy];
            [widthImageRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<img src=\"assets/iphone ui/$1.png\" width=\"22\" />"];
            [heightImageRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<img src=\"assets/iphone ui/$1.png\" height=\"22\" />"];
            [linkRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"$1\">$1</a>"];
            [boldRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<b>$1</b>"];
            [empireProfileRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"empire://$1\">$2</a>"];
            [allianceProfileRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"alliance://$1\">$2</a>"];
            [myPlanetRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"myplanet://$1\">$2</a>"];
            [starmapRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"starmap://$1.$2\">$3</a>"];
            [voteYesRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"voteYes://$1.$2.$3\">Yes!</a>"];
            [voteNoRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<a href=\"voteNo://$1.$2.$3\">No!</a>"];
            [newlineRegex replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length]) withTemplate:@"<br />"];
            htmlString = [NSString stringWithFormat:@"<html><head><style>a:link {color:#FFC000;}</style></head><body style=\"background-color:transparent; color: #FFF; width: %f; font-family: sans-serif; font-size: 14px;\"><div style=\"margin: 5px 10px 5px 5px;\">%@</div></body></html>", self.webView.frame.size.width-20, mutableString];
            [mutableString release];
        } else {
            htmlString = [NSString stringWithFormat:@"<html><head><style>a:link {color:#FFC000;}</style></head><body style=\"background-color:transparent; color: #FFF; width: %f; font-family: sans-serif; font-size: 14px;\"></body></html>", self.webView.frame.size.width-20];
        }
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:htmlString baseURL:baseURL];
    }
}


- (void)displayContent {
}


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (!self->loadingContent) {
		NSURL *url = [request URL];
		if ([url.scheme isEqualToString:@"empire"]) {
			[self.delegate showEmpireProfile:url.host];
		} else if ([url.scheme isEqualToString:@"alliance"]) {
			[self.delegate showAllianceProfile:url.host];
		} else if ([url.scheme isEqualToString:@"myplanet"]) {
			[self.delegate showMyPlanet:url.host];
		} else if ([url.scheme isEqualToString:@"starmap"]) {
			[self.delegate showStarmap:url.host];
		} else if ([url.scheme isEqualToString:@"voteYes"]) {
            NSArray *parts = [url.host componentsSeparatedByString: @"."];
			[self.delegate voteYesForBody:[parts objectAtIndex:0] building:[parts objectAtIndex:1] proposition:[parts objectAtIndex:2]];
		} else if ([url.scheme isEqualToString:@"voteNo"]) {
            NSArray *parts = [url.host componentsSeparatedByString: @"."];
			[self.delegate voteNoForBody:[parts objectAtIndex:0] building:[parts objectAtIndex:1] proposition:[parts objectAtIndex:2]];
		} else {
			NSString *urlAsString = [[request URL] absoluteString];
			if ([[urlAsString substringToIndex:4] isEqualToString:@"https"]) {
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

+ (LETableViewCellWebView *)getCellForTableView:(UITableView *)tableView dequeueable:(BOOL)isDequeueable {
	static NSString *CellIdentifier = @"WebViewCell";
	
	LETableViewCellWebView *cell = nil;
    if (isDequeueable) {
        cell = (LETableViewCellWebView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if (cell == nil) {
        if (isDequeueable) {
            cell = [[[LETableViewCellWebView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        } else {
            cell = [[[LETableViewCellWebView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        }
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.height = MIN_HEIGHT;
		
		cell.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 34)] autorelease];
		cell.webView.backgroundColor = [UIColor clearColor];
		cell.webView.autoresizesSubviews = YES;
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

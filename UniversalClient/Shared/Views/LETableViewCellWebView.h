//
//  LETableViewCellWebView.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LETableViewCellWebViewDelegate


- (void)showWebPage:(NSString*)url;
- (void)showEmpireProfile:(NSString *)empireId;


@end


@interface LETableViewCellWebView : UITableViewCell <UIWebViewDelegate> {
	UIWebView *webView;
	BOOL loadingContent;
	NSInteger height;
	id<LETableViewCellWebViewDelegate> delegate;
}


@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) id<LETableViewCellWebViewDelegate> delegate;


- (void)setContent:(NSString *)content;


+ (LETableViewCellWebView *)getCellForTableView:(UITableView *)tableView;


@end

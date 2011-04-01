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
- (void)showAllianceProfile:(NSString *)allianceId;
- (void)showMyPlanet:(NSString *)myPlanetId;
- (void)showStarmap:(NSString *)starmapLoc;
- (void)voteYesForBody:(NSString *)bodyId building:(NSString *)buildingId proposition:(NSString *)propositionId;
- (void)voteNoForBody:(NSString *)bodyId building:(NSString *)buildingId proposition:(NSString *)propositionId;


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
@property(nonatomic, retain) NSString *origContent;


- (void)setContent:(NSString *)content;

+ (LETableViewCellWebView *)getCellForTableView:(UITableView *)tableView dequeueable:(BOOL)isDequeueable;


@end

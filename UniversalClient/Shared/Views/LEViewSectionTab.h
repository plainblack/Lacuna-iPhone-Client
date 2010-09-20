//
//  LEViewSectionTab.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/7/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LEViewSectionTab : UIView {
	UIImageView *icon;
	UILabel *label;
}


@property(nonatomic, retain) UIImageView *icon;
@property(nonatomic, retain) UILabel *label;


+ (LEViewSectionTab *)tableView:(UITableView *)tableView withText:(NSString *)text;
+ (LEViewSectionTab *)tableView:(UITableView *)tableView withText:(NSString *)text withIcon:(UIImage *)icon;
+ (CGFloat)getHeight;


@end

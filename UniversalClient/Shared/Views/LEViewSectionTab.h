//
//  LEViewSectionTab.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/7/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LEViewSectionTab : UIView {
	UILabel *label;
}


@property(nonatomic, retain) UILabel *label;


+ (LEViewSectionTab *)tableView:(UITableView *)tableView withText:(NSString *)text;
+ (CGFloat)getHeight;


@end

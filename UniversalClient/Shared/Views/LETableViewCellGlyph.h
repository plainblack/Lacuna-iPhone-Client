//
//  LETableViewCellGlyph.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Glyph;


@interface LETableViewCellGlyph : UITableViewCell {
	UIImageView *imageView;
	UILabel *content;
}


@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UILabel *content;


- (void)setGlyph:(Glyph *)glyph;


+ (LETableViewCellGlyph *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

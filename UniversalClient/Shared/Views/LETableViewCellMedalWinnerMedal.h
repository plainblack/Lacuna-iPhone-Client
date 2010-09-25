//
//  LETableViewCellMedalImageName.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellMedalWinnerMedal : UITableViewCell {
	UILabel *medalNameLabel;
	UILabel *dateLabel;
	UITextView *noteView;
	UIImageView *imageView;
}


@property(nonatomic,retain) IBOutlet UILabel *medalNameLabel;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;


- (void)setData:(NSDictionary *)data;


+ (LETableViewCellMedalWinnerMedal *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

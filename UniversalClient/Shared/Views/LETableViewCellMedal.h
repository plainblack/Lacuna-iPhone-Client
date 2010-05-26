//
//  LETableViewCellMedal.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellMedal : UITableViewCell {
	UILabel *medalNameLabel;
	UILabel *dateLabel;
	UITextView *noteView;
	UIImageView *imageView;
}


@property(nonatomic,retain) IBOutlet UILabel *medalNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *dateLabel;
@property(nonatomic,retain) IBOutlet UITextView *noteView;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;


+ (LETableViewCellMedal *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView withMedal:(NSDictionary *)medal;


@end

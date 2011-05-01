//
//  LETableViewCellMailSelect.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellMailSelect : UITableViewCell {
}


@property (nonatomic, retain) UIImageView *selectedImageView;
@property (nonatomic, retain) UILabel *subjectText;
@property (nonatomic, retain) UILabel *fromLabel;
@property (nonatomic, retain) UILabel *fromText;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *dateText;


- (void)setMessage:(NSDictionary *)message;
- (void)selectForDelete;
- (void)unselectForDelete;


+ (LETableViewCellMailSelect *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

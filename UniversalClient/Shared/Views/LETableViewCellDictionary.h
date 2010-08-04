//
//  LETableViewCellDictionary.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellDictionary : UITableViewCell {
	UILabel *headingLabel;
	NSMutableArray *dataLabels;
	NSMutableArray *keys;
}


@property(nonatomic, retain) UILabel *headingLabel;
@property(nonatomic, retain) NSMutableArray *keys;
@property(nonatomic, retain) NSMutableArray *values;


- (void)setHeading:(NSString *)heading Data:(NSDictionary *)data;


+ (LETableViewCellDictionary *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView numItems:(NSInteger)numItems;


@end

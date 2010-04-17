//
//  LETableViewCellUnbuildable.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellUnbuildable : UITableViewCell {
	UILabel *reasonLabel;
}


@property(nonatomic, retain) IBOutlet UILabel *reasonLabel;


- (void)setReason:(NSString *)reason;


+ (LETableViewCellUnbuildable *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

//
//  LETableViewCellProgress.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimedActivity.h"


@interface LETableViewCellProgress : UITableViewCell {
	UIProgressView *progressView;
	UILabel *secondsLabel;
	TimedActivity *timedActivity;
}


@property(nonatomic, retain) IBOutlet UIProgressView *progressView;
@property(nonatomic, retain) IBOutlet UILabel *secondsLabel;
@property(nonatomic, retain) TimedActivity *timedActivity;


- (void)bindToTimedActivity:(TimedActivity *)timedActivity;


+ (LETableViewCellProgress *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

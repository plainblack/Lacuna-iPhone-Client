//
//  LETableViewCellProgress.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LETableViewCellProgressDelegate
- (void)progressComplete;
@end


@interface LETableViewCellProgress : UITableViewCell {
	UIProgressView *progressView;
	UILabel *secondsLabel;
	id<LETableViewCellProgressDelegate> delegate;
	NSInteger totalTime;
	NSInteger remainingTime;
	NSTimer *timer;
}


@property(nonatomic, retain) IBOutlet UIProgressView *progressView;
@property(nonatomic, retain) IBOutlet UILabel *secondsLabel;
@property(nonatomic, assign) id<LETableViewCellProgressDelegate> delegate;
@property(nonatomic, assign) NSTimer *timer;


- (void)setTotalTime:(NSInteger)totalTime remainingTime:(NSInteger)remainingTime;
- (void)handleTimer:(NSTimer *)theTimer;


+ (LETableViewCellProgress *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

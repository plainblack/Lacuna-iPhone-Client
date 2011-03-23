//
//  LETableViewCellVotes.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/22/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellVotes : UITableViewCell {
}


@property (nonatomic, retain) IBOutlet UILabel *votesNeededLabel;
@property (nonatomic, retain) IBOutlet UILabel *votesForLabel;
@property (nonatomic, retain) IBOutlet UILabel *votesAgainstLabel;


- (void)setVotesNeeded:(NSDecimalNumber *)votesNeeded votesFor:(NSDecimalNumber *)votesFor votesAgainst:(NSDecimalNumber *)votesAgainst;


+ (LETableViewCellVotes *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

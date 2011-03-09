//
//  LETableViewCellSpyInfo.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Spy;


@interface LETableViewCellSpyInfo : UITableViewCell {
}


@property(nonatomic, retain) UILabel *nameContent;
@property(nonatomic, retain) UILabel *locationContent;
@property(nonatomic, retain) UILabel *assignmentContent;
@property(nonatomic, retain) UILabel *levelContent;
@property(nonatomic, retain) UILabel *politicsExpContent;
@property(nonatomic, retain) UILabel *mayhemExpContent;
@property(nonatomic, retain) UILabel *theftExpContent;
@property(nonatomic, retain) UILabel *intelExpContent;
@property(nonatomic, retain) UILabel *offenseRatingContent;
@property(nonatomic, retain) UILabel *defenseRatingContent;
@property(nonatomic, retain) UILabel *numOffensiveMissionsContent;
@property(nonatomic, retain) UILabel *numDefensiveMissionsContent;


- (void)setData:(Spy *)spy;


+ (LETableViewCellSpyInfo *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

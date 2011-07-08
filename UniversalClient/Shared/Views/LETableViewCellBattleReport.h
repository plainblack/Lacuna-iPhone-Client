//
//  LETableViewCellBattleReport.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellBattleReport : UITableViewCell {
}


@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *attackerNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *attackerFromLabel;
@property(nonatomic, retain) IBOutlet UILabel *attackerUnitLabel;
@property(nonatomic, retain) IBOutlet UILabel *defenderNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *defenderFromLabel;
@property(nonatomic, retain) IBOutlet UILabel *defenderUnitLabel;
@property(nonatomic, retain) IBOutlet UILabel *victorLabel;


- (void)setBattleLog:(NSMutableDictionary *)battleLog;


+ (LETableViewCellBattleReport *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

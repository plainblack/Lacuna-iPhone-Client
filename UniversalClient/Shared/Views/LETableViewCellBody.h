//
//  LETableViewCellBody.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellBody : UITableViewCell {
	UIImageView *planetImageView;
	UILabel *planetLabel;
	UILabel	*systemLabel;
	UILabel *orbitLabel;
	UILabel	*empireLabel;
}


@property(nonatomic, retain) IBOutlet UIImageView *planetImageView;
@property(nonatomic, retain) IBOutlet UILabel *planetLabel;
@property(nonatomic, retain) IBOutlet UILabel *systemLabel;
@property(nonatomic, retain) IBOutlet UILabel *orbitLabel;
@property(nonatomic, retain) IBOutlet UILabel *empireLabel;


+ (LETableViewCellBody *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

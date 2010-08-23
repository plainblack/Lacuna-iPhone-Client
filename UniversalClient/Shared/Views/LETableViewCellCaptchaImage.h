//
//  LETableViewCellCaptchaImage.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellCaptchaImage : UITableViewCell {
	UIImageView *imageView;
}


@property (nonatomic, retain) UIImageView *imageView;


- (void)setCapthchaImageURL:(NSString *)url;


+ (LETableViewCellCaptchaImage *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end

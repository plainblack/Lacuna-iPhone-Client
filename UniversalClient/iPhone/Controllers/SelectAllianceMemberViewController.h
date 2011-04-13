//
//  SelectAllianceMemberViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SelectAllianceMemberViewControllerDelegate

- (void)selectedAllianceMember:(NSDictionary *)empire;

@end


@interface SelectAllianceMemberViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) NSString *allianceId;
@property (nonatomic, retain) NSMutableArray *allianceMembers;
@property (nonatomic, assign) id<SelectAllianceMemberViewControllerDelegate> delegate;


+ (SelectAllianceMemberViewController *)create;


@end

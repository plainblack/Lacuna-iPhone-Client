//
//  ViewStatsControllerV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewStatsControllerV2 : LETableViewControllerGrouped {
}


- (IBAction)logout;


+ (ViewStatsControllerV2 *) create;


@end

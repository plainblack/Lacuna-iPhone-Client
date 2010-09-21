//
//  ViewBodyMapControllerV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LEBodyGetBuildings;


@interface ViewBodyMapControllerV2 : UITableViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIView *backgroundView;
	NSMutableDictionary *buttonsByLoc;
	UILabel *plotsLabel;
}


@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIView *backgroundView;
@property(nonatomic, retain) IBOutlet UILabel *plotsLabel;


@end

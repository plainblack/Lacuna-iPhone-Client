//
//  ViewBodyMapController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LEGetBuildings;


@interface ViewBodyMapController : UIViewController {
	UIScrollView *scrollView;
	NSString *bodyId;
	NSString *bodyName;
	NSNumber *maxBuildings;
	NSMutableDictionary *buildings;
	NSMutableDictionary *buttonsByLoc;
	NSMutableDictionary *locsByButton;
	LEGetBuildings *leGetBuildings;
	NSTimer *reloadTimer;
}


@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSString *bodyName;
@property(nonatomic, retain) NSNumber *maxBuildings;
@property(nonatomic, retain) NSMutableDictionary *buildings;
@property(nonatomic, retain) LEGetBuildings *leGetBuildings;
@property(nonatomic, retain) NSTimer *reloadTimer;


@end

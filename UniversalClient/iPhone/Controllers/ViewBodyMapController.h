//
//  ViewBodyMapController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LEBodyGetBuildings;


@interface ViewBodyMapController : UIViewController {
	UIScrollView *scrollView;
	UIView *backgroundView;
	NSMutableDictionary *buttonsByLoc;
	NSMutableDictionary *locsByButton;
}


@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIView *backgroundView;


@end

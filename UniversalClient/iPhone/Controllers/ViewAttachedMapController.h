//
//  ViewAttachedMapController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewAttachedMapController : UIViewController {
	UIScrollView *scrollView;
	UIView *backgroundView;
	NSString *surface;
	NSArray *buildings;
}


@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIView *backgroundView;
@property(nonatomic, retain) NSString *surface;
@property(nonatomic, retain) NSArray *buildings;


-(void) setAttachedMap:(NSDictionary *)attachedMap;


@end

//
//  ViewUniverseController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StarMap;


@interface ViewUniverseController : UIViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIView *map;
	NSMutableDictionary *inUseCells;
	NSMutableArray *reusableCells;
	StarMap *starMap;
}


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *map;
@property (nonatomic, retain) NSMutableDictionary *inUseCells;
@property (nonatomic, retain) NSMutableArray *reusableCells;
@property (nonatomic, retain) StarMap *starMap;


- (IBAction)logout;


@end

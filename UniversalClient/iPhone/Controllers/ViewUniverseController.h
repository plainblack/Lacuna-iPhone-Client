//
//  ViewUniverseController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniverseGotoController.h"

@class StarMap;


@interface ViewUniverseController : UIViewController <UIScrollViewDelegate, UniverseGotoControllerDelegate> {
	BOOL isUpdating;
}


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *map;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) NSMutableDictionary *inUseStarCells;
@property (nonatomic, retain) NSMutableArray *reusableStarCells;
@property (nonatomic, retain) NSMutableDictionary *inUseBodyCells;
@property (nonatomic, retain) NSMutableArray *reusableBodyCells;
@property (nonatomic, retain) StarMap *starMap;
@property (nonatomic, retain) NSDecimalNumber *gotoGridX;
@property (nonatomic, retain) NSDecimalNumber *gotoGridY;


- (IBAction)logout;
- (IBAction)showGotoPage;
- (IBAction)clear;
- (void)gotoGridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY;


@end

//
//  ViewTipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewTipsController : UIViewController {
	NSInteger currentTipIdx;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITextView *tipTextView;
@property (nonatomic, retain) NSMutableArray *tips;


- (IBAction)previousTip;
- (IBAction)nextTip;


@end

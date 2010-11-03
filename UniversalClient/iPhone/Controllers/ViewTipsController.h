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
@property (nonatomic, retain) IBOutlet UILabel *tipLabel;
@property (nonatomic, retain) IBOutlet UITextView *tipTextView;
@property (nonatomic, retain) IBOutlet UISwitch *tipAlertSwitch;
@property (nonatomic, retain) NSMutableArray *tips;


- (IBAction)previousTip;
- (IBAction)nextTip;
- (IBAction)toggleTipAlert;


@end

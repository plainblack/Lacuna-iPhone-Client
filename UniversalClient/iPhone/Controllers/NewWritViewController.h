//
//  NewWritViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Parliament;
@class LETableViewCellTextEntry;
@class LETableViewCellLabeledTextView;


@interface NewWritViewController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;
@property (nonatomic, retain) LETableViewCellLabeledTextView *messageCell;


- (IBAction)propose;


+ (NewWritViewController *) create;


@end

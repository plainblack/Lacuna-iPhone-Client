//
//  CaptchaViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LERequest;
@class LETableViewCellTextEntry;


@interface CaptchaViewController : LETableViewControllerGrouped <UITextFieldDelegate> {
}


@property(nonatomic, retain) LERequest *requestNeedingCaptcha;
@property(nonatomic, retain) LETableViewCellTextEntry *answerCell;
@property(nonatomic, retain) NSString *captchaGuid;
@property(nonatomic, retain) NSString *captchaUrl;


+ (CaptchaViewController *) create;


@end

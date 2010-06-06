//
//  EditEmpireProfileText.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextView.h"
#import "LEEmpireViewProfile.h"


@interface EditEmpireProfileText : LETableViewControllerGrouped {
	LETableViewCellTextView *textCell;
	NSString *textName;
	NSString *textKey;
	LEEmpireViewProfile *leEmpireViewProfile;
}


@property(nonatomic, retain) LETableViewCellTextView *textCell;
@property(nonatomic, retain) NSString *textName;
@property(nonatomic, retain) NSString *textKey;
@property(nonatomic, retain) LEEmpireViewProfile *leEmpireViewProfile;


+ (EditEmpireProfileText *)createForLEEmpireViewProfile:(LEEmpireViewProfile *)leEmpireViewProfile textName:(NSString *)name textKey:(NSString *)key text:(NSString *)text;


@end

//
//  ViewDictionaryController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewDictionaryController : LETableViewControllerGrouped {
	NSString *name;
	UIImage *icon;
	BOOL useLongLabels;
}


@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSArray *keysSorted;


+ (ViewDictionaryController *)createWithName:(NSString *)name useLongLabels:(BOOL)useLongLabels icon:(UIImage *)icon;


@end

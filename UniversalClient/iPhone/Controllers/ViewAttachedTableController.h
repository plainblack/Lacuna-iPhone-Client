//
//  ViewAttachedTableController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewAttachedTableController : UITableViewController {
	NSArray *headers;
	NSArray *sections;
}


@property(nonatomic, retain) NSArray *headers;
@property(nonatomic, retain) NSArray *sections;


- (void)setAttachedTable:(NSArray *)attachedTable;


@end

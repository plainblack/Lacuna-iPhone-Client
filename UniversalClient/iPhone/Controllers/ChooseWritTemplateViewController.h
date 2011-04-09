//
//  ChooseWritTemplateViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellWebView.h"


@class Parliament;


@interface ChooseWritTemplateViewController : LETableViewControllerGrouped <LETableViewCellWebViewDelegate> {
}


@property (nonatomic, retain) NSMutableArray *writTemplates;
@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSMutableDictionary *webViewCells;


- (LETableViewCellWebView *)getCellForIndexPath:(NSIndexPath *)indexPath;


+ (ChooseWritTemplateViewController *)create;


@end

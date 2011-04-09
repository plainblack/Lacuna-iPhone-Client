//
//  ViewLawController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellWebView.h"


@class Parliament;


@interface ViewLawsController : LETableViewControllerGrouped <LETableViewCellWebViewDelegate> {
    BOOL watchingLaws;
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSMutableDictionary *webViewCells;


- (LETableViewCellWebView *)getCellForIndexPath:(NSIndexPath *)indexPath;


+ (ViewLawsController *)create;


@end

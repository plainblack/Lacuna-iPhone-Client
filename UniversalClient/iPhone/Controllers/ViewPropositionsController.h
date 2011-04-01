//
//  ViewPropositionsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellWebView.h"


@class Parliament;


@interface ViewPropositionsController : LETableViewControllerGrouped <LETableViewCellWebViewDelegate> {
    BOOL watchingPropositions;
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSMutableDictionary *webViewCells;


- (LETableViewCellWebView *)getCellForIndexPath:(NSIndexPath *)indexPath;


+ (ViewPropositionsController *)create;


@end

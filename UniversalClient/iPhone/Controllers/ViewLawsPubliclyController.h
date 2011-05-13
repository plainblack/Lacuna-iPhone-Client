//
//  ViewLawsPubliclyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellWebView.h"


@interface ViewLawsPubliclyController : LETableViewControllerGrouped <LETableViewCellWebViewDelegate> {
}


@property (nonatomic, retain) NSString *stationId;
@property (nonatomic, retain) NSArray *laws;
@property (nonatomic, retain) NSMutableDictionary *webViewCells;


- (LETableViewCellWebView *)getCellForIndexPath:(NSIndexPath *)indexPath;


+ (ViewLawsPubliclyController *)create;


@end

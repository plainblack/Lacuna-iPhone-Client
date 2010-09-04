//
//  LEEmpireEnableSelfDestruct.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireEnableSelfDestruct : LERequest {

}

- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end

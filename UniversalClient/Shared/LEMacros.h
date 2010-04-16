//
//  LEMacros.h
//  DKTest
//
//  Created by Kevin Runde on 3/28/10.
//  Copyright 2010 n/a. All rights reserved.
//
#import	<UIKit/UIKit.h>

#define array_(__args...) [NSArray arrayWithObjects:__args, nil]
#define dict_(__args...) [NSDictionary dictionaryWithObjectsAndKeys:__args, nil]
#define intv_(__o) [__o intValue]

//#define CELL_BACKGROUND_COLOR [UIColor colorWithRed:(244/255.0) green:(215/255.0) blue:(78/255.0) alpha:1.0]
#define CELL_BACKGROUND_IMAGE [UIImage imageNamed:@"assets/ui/bkg.png"]
#define CELL_BACKGROUND_COLOR [UIColor colorWithPatternImage:CELL_BACKGROUND_IMAGE]
#define LE_BLUE [UIColor colorWithRed:82.0/255.0 green:172.0/255.0 blue:1.0 alpha:1.0]

//FONT SETTINGS
#define LABEL_COLOR [UIColor colorWithWhite:0.4 alpha:1.0]
#define LABEL_SMALL_COLOR [UIColor colorWithWhite:0.4 alpha:1.0]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SMALL_COLOR [UIColor blackColor]
#define PARAGRAPH_COLOR [UIColor blackColor]
#define TEXT_ENTRY_COLOR [UIColor blackColor]
#define BUTTON_TEXT_COLOR [UIColor blueColor];
#define HEADER_TEXT_COLOR [UIColor whiteColor];

#define LABEL_FONT [UIFont fontWithName:@"Verdana" size:12.0]
#define LABEL_SMALL_FONT [UIFont fontWithName:@"Verdana" size:10.0]
#define MESSAGE_FONT [UIFont fontWithName:@"Verdana" size:12.0]
#define PARAGRAPH_FONT [UIFont fontWithName:@"Verdana" size:14.0]
#define TEXT_FONT [UIFont fontWithName:@"Verdana" size:16.0]
#define TEXT_SMALL_FONT [UIFont fontWithName:@"Verdana" size:10.0]
#define TEXT_ENTRY_FONT [UIFont fontWithName:@"Verdana" size:18.0]
#define HEADER_TEXT_FONT [UIFont fontWithName:@"Verdana" size:18.0];

//Settins
#define NUM_ORBITS 7



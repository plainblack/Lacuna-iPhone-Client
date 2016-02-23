//
//  LEMacros.h
//  DKTest
//
//  Created by Kevin Runde on 3/28/10.
//  Copyright 2010 n/a. All rights reserved.
//
#import	<UIKit/UIKit.h>

#define _array(__args...) [NSMutableArray arrayWithObjects:__args, nil]
#define _boolv(__o) [__o boolValue]
#define _dict(__args...) [NSMutableDictionary dictionaryWithObjectsAndKeys:__args, nil]
#define _intv(__o) [__o intValue]
#define NSRangeZero NSMakeRange(0,0)
#define isNull(__o) (__o == nil || ((id)__o == [NSNull null]))
#define isNotNull(__o) (__o && ((id)__o != [NSNull null]))
#define isNotEmptyString(__o) (__o && ((id)__o != [NSNull null]) && [__o length]>0)

//Supported Server Version
#define SERVER_MAJOR 3
#define API_KEY @"iOS"

//Time defs
#define SEC_IN_HOUR (1.0 * 60.0 * 60.0) // 1hr, 60 min, 60 sec

//Images
#define ENERGY_ICON [UIImage imageNamed:@"assets/iphone ui/energy.png"]
#define ESSENTIA_ICON [UIImage imageNamed:@"assets/iphone ui/essentia.png"]
#define FOOD_ICON [UIImage imageNamed:@"assets/iphone ui/food.png"]
#define HAPPINESS_ICON [UIImage imageNamed:@"assets/iphone ui/happiness.png"]
#define ORE_ICON [UIImage imageNamed:@"assets/iphone ui/ore.png"]
#define PLOTS_ICON [UIImage imageNamed:@"assets/iphone ui/plots.png"]
#define TIME_ICON [UIImage imageNamed:@"assets/iphone ui/time.png"]
#define WASTE_ICON [UIImage imageNamed:@"assets/iphone ui/waste.png"]
#define WATER_ICON [UIImage imageNamed:@"assets/iphone ui/water.png"]
#define STORAGE_ICON [UIImage imageNamed:@"assets/iphone ui/storage.png"]
#define BUILD_ICON [UIImage imageNamed:@"assets/iphone ui/build.png"]
#define UP_ARROW_ICON [UIImage imageNamed:@"assets/iphone ui/icon_arrow_up.png"]
#define DOWN_ARROW_ICON [UIImage imageNamed:@"assets/iphone ui/icon_arrow_down.png"]
#define SPY_ICON [UIImage imageNamed:@"assets/iphone ui/spy.png"]

//Colors
#define CELL_BACKGROUND_IMAGE [UIImage imageNamed:@"assets/iphone ui/cell-bkg.png"]
#define CELL_BACKGROUND_COLOR [UIColor colorWithPatternImage:CELL_BACKGROUND_IMAGE]
#define STAR_FIELD_BACKGROUND_MAGE [UIImage imageNamed:@"assets/star_system/field.png"]
#define STAR_FIELD_BACKGROUND_COLOR [UIColor colorWithPatternImage:STAR_FIELD_BACKGROUND_MAGE]
#define TOP_CELL_BACKGROUND_IMAGE [UIImage imageNamed:@"assets/iphone ui/cell-bkg-top.png"]
#define TOP_CELL_BACKGROUND_COLOR [UIColor colorWithPatternImage:TOP_CELL_BACKGROUND_IMAGE]
#define LE_BLUE [UIColor colorWithRed:82.0/255.0 green:172.0/255.0 blue:1.0 alpha:1.0]
#define TINT_COLOR [UIColor colorWithRed:11.0/255.0 green:82.0/255.0 blue:163.0/255.0 alpha:1.0]
#define SEPARATOR_COLOR [UIColor whiteColor]

//FONT SETTINGS
#define LABEL_COLOR [UIColor blackColor]
#define LABEL_SMALL_COLOR [UIColor blackColor]
#define TEXT_COLOR [UIColor whiteColor]
#define TEXT_SMALL_COLOR [UIColor whiteColor]
#define PARAGRAPH_COLOR [UIColor whiteColor]
#define TEXT_ENTRY_COLOR [UIColor blackColor]
#define BUTTON_TEXT_COLOR [UIColor colorWithRed:1.0 green:192.0/255.0 blue:0.0 alpha:1.0]
#define HEADER_TEXT_COLOR [UIColor colorWithRed:1.0 green:192.0/255.0 blue:0.0 alpha:1.0]
#define WARNING_COLOR [UIColor yellowColor]
#define MAIL_TEXT_COLOR [UIColor blackColor]
#define UNREAD_MAIL_TEXT_COLOR [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]

#define LABEL_FONT [UIFont fontWithName:@"Verdana" size:12.0]
#define LABEL_SMALL_FONT [UIFont fontWithName:@"Verdana" size:10.0]
#define MESSAGE_FONT [UIFont fontWithName:@"Verdana" size:12.0]
#define PARAGRAPH_FONT [UIFont fontWithName:@"Verdana" size:14.0]
#define TEXT_FONT [UIFont fontWithName:@"Verdana" size:16.0]
#define TEXT_SMALL_FONT [UIFont fontWithName:@"Verdana" size:10.0]
#define TEXT_ENTRY_FONT [UIFont fontWithName:@"Verdana" size:18.0]
#define HEADER_TEXT_FONT [UIFont fontWithName:@"Verdana-Bold" size:18.0]
#define BUTTON_TEXT_FONT [UIFont fontWithName:@"Verdana-Bold" size:16.0]

//Settins
#define NUM_ORBITS 8

//BODY_BUILDINGS
#define BODY_BUILDINGS_NUM_ROWS 11
#define BODY_BUILDINGS_NUM_COLS 11
#define BODY_BUILDINGS_CELL_HEIGHT 100
#define BODY_BUILDINGS_CELL_WIDTH 100
#define BODY_BUILDINGS_MIN_X -5
#define BODY_BUILDINGS_MAX_X 5
#define BODY_BUILDINGS_MIN_Y -5
#define BODY_BUILDINGS_MAX_Y 5

//Items Per Page
#define ITEMS_PER_PAGE 25

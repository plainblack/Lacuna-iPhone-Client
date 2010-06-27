    //
//  ViewBodyMapController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBodyMapController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBodyGetBuildings.h"
#import "ViewBuildingController.h"
#import "NewBuildingController.h"
#import "Session.h"


@implementation ViewBodyMapController


@synthesize scrollView;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];
	self.scrollView.autoresizesSubviews = YES;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.scrollView.bounces = NO;
	self.view = self.scrollView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	Session *session = [Session sharedInstance];
	
	self.scrollView.contentSize = CGSizeMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT);
	self.scrollView.contentOffset = CGPointMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH/2 - self.scrollView.center.x, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT/2 - self.scrollView.center.y);
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	buttonsByLoc = [[NSMutableDictionary alloc] initWithCapacity:BODY_BUILDINGS_NUM_ROWS*BODY_BUILDINGS_NUM_COLS];
	locsByButton = [[NSMutableDictionary alloc] initWithCapacity:BODY_BUILDINGS_NUM_ROWS*BODY_BUILDINGS_NUM_COLS];
	int currentX = 0;
	for (int x=BODY_BUILDINGS_MIN_X; x<=BODY_BUILDINGS_MAX_X; x++) {
		int currentY = 0;
		for (int y=BODY_BUILDINGS_MAX_Y; y>=BODY_BUILDINGS_MIN_Y; y--) {
			NSString *loc = [NSString stringWithFormat:@"%ix%i", x, y];
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.autoresizesSubviews = YES;
			[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
			button.frame = CGRectMake(currentX, currentY, BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_CELL_HEIGHT);
			button.contentMode = UIViewContentModeScaleToFill;
			button.imageView.contentMode = UIViewContentModeScaleToFill;
			button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
			[self.scrollView addSubview:button];
			[buttonsByLoc setObject:button forKey:loc];
			[locsByButton setObject:loc forKey:[NSValue valueWithNonretainedObject:button]];

			NSDictionary *building = [session.body.buildingMap objectForKey:loc];
			if (building) {
				[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [building objectForKey:@"image"]]] forState:UIControlStateNormal];
			} else {
				[button setBackgroundImage:[UIImage imageNamed:@"/assets/planet_side/build.png"] forState:UIControlStateNormal];
			}
			
			currentY += BODY_BUILDINGS_CELL_HEIGHT;
		}
		currentX += BODY_BUILDINGS_CELL_WIDTH;
	}
	
	if (session.body.surfaceImageName) {
		UIImage *surfaceImage = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]];
		self.scrollView.backgroundColor = [UIColor colorWithPatternImage:surfaceImage];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];
	[session addObserver:self forKeyPath:@"body.buildingMap" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session.body loadBuildingMap];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Loading"];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	Session *session = [Session sharedInstance];
	[session removeObserver:self forKeyPath:@"body.buildingMap"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
	self.scrollView = nil;
	[buttonsByLoc release];
	buttonsByLoc = nil;
	[locsByButton release];
	locsByButton = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (void)buttonClicked:(id)sender {
	Session *session = [Session sharedInstance];
	NSString *loc = [locsByButton objectForKey:[NSValue valueWithNonretainedObject:sender]];
	NSDictionary *building = [session.body.buildingMap objectForKey:loc];
	NSInteger tmp;
	NSNumber *x;
	NSNumber *y;
	NSScanner *scanner = [NSScanner scannerWithString:loc];
	[scanner scanInteger:&tmp];
	x = [NSNumber numberWithInt:tmp];
	[scanner setScanLocation:[scanner scanLocation]+1];
	[scanner scanInteger:&tmp];
	y = [NSNumber numberWithInt:tmp];

	if (building) {
		ViewBuildingController *viewBuildingController = [ViewBuildingController create];
		viewBuildingController.buildingId = [building objectForKey:@"id"];
		viewBuildingController.urlPart = [building objectForKey:@"url"];
		viewBuildingController.buildingsByLoc = session.body.buildingMap;
		viewBuildingController.buttonsByLoc = buttonsByLoc;
		[[self navigationController] pushViewController:viewBuildingController animated:YES];
	} else {
		Session *session = [Session sharedInstance];
		NewBuildingController *newBuildingController = [NewBuildingController create];
		newBuildingController.bodyId = session.body.id;
		newBuildingController.buildingsByLoc = session.body.buildingMap;
		newBuildingController.buttonsByLoc = buttonsByLoc;
		[[self navigationController] pushViewController:newBuildingController animated:YES];
	}

}


#pragma mark --
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"body.buildingMap"]) {
		Session *session = [Session sharedInstance];
		UIImage *surfaceImage = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]];
		self.scrollView.backgroundColor = [UIColor colorWithPatternImage:surfaceImage];
		
		for (int x=BODY_BUILDINGS_MIN_X; x<=BODY_BUILDINGS_MAX_X; x++) {
			for (int y=BODY_BUILDINGS_MIN_Y; y<=BODY_BUILDINGS_MAX_Y; y++) {
				NSString *key = [NSString stringWithFormat:@"%ix%i", x, y];
				UIButton *button = [buttonsByLoc objectForKey:key];
				NSDictionary *building = [session.body.buildingMap objectForKey:key];
				
				if (building) {
					[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [building objectForKey:@"image"]]] forState:UIControlStateNormal];
				} else {
					[button setBackgroundImage:[UIImage imageNamed:@"/assets/planet_side/build.png"] forState:UIControlStateNormal];
				}
			}
		}
		self.navigationItem.title = [NSString stringWithFormat:@"%i/%i Buildings", [session.body.buildingMap count], session.body.size];
	}
}


@end

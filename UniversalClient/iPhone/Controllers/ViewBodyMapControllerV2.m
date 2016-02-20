//
//  ViewBodyMapControllerV2.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBodyMapControllerV2.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEBodyMapCell.h"
#import "MapBuilding.h"
#import "ViewBuildingController.h"
#import "NewBuildingTypeController.h"

@implementation ViewBodyMapControllerV2


@synthesize scrollView;
@synthesize backgroundView;
@synthesize plotsLabel;

- (void)loadView {
	self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];
	self.scrollView.autoresizesSubviews = YES;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.scrollView.bounces = NO;
	self.scrollView.bouncesZoom = NO;
	self.scrollView.delegate = self;
	self.scrollView.maximumZoomScale = 4.0;
	self.scrollView.minimumZoomScale = 0.35;
	self.view = self.scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	Session *session = [Session sharedInstance];

	self.scrollView.contentSize = CGSizeMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT);
	self.scrollView.contentOffset = CGPointMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH/2 - self.scrollView.center.x, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT/2 - self.scrollView.center.y);
	
	self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)] autorelease];
	self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
	self.backgroundView.autoresizingMask = UIViewAutoresizingNone;
	[self.scrollView addSubview:self.backgroundView];
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;

	self.plotsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 22.0)] autorelease];
	self.plotsLabel.font = TEXT_FONT;
	self.plotsLabel.textColor = TEXT_COLOR;
	self.plotsLabel.backgroundColor = [UIColor clearColor];
	self.plotsLabel.text = [NSString stringWithFormat:@"%@ Available", session.body.plotsAvailable];
	UIBarButtonItem *numOfPlotsBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.plotsLabel] autorelease];
	UIImageView *plotIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22.0, 22.0)] autorelease];
	plotIconView.image = PLOTS_ICON;
	UIBarButtonItem *plotIconBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:plotIconView] autorelease];
	UIBarButtonItem *flexable = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem	*pageCurl = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(switchOverlay)] autorelease];
	[self setToolbarItems:_array(plotIconBarButtonItem, numOfPlotsBarButtonItem, flexable, pageCurl) animated:NO];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	BOOL showMapOverlay = [userDefaults boolForKey:@"showMapOverlay"];
	buttonsByLoc = [[NSMutableDictionary alloc] initWithCapacity:BODY_BUILDINGS_NUM_ROWS*BODY_BUILDINGS_NUM_COLS];
	int currentX = 0;
	for (int x=BODY_BUILDINGS_MIN_X; x<=BODY_BUILDINGS_MAX_X; x++) {
		int currentY = 0;
		for (int y=BODY_BUILDINGS_MAX_Y; y>=BODY_BUILDINGS_MIN_Y; y--) {
			NSString *loc = [NSString stringWithFormat:@"%ix%i", x, y];
			LEBodyMapCell *button = [[[LEBodyMapCell alloc] initWithFrame:CGRectMake(currentX, currentY, BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_CELL_HEIGHT)] autorelease];
			button.buildingX = [Util decimalFromInt:x];
			button.buildingY = [Util decimalFromInt:y];
			[button target:self callback:@selector(mapCellClicked:)];
			[self.backgroundView addSubview:button];
			[buttonsByLoc setObject:button forKey:loc];
			button.showOverlay = showMapOverlay;
			
			MapBuilding *mapBuilding = [session.body.buildingMap objectForKey:loc];
			if (isNotNull(mapBuilding)) {
				button.mapBuilding = mapBuilding;
			} else {
				button.mapBuilding = nil;
			}
			
			currentY += BODY_BUILDINGS_CELL_HEIGHT;
		}
		currentX += BODY_BUILDINGS_CELL_WIDTH;
	}
	
	if (session.body.surfaceImageName) {
		UIImage *surfaceImage = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]];
		self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:surfaceImage];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];

	if (session.body.currentBuilding) {
		[session.body clearBuilding];
	}
	
	self.navigationItem.title = session.body.name;
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	float bodyMapZoom = [userDefaults floatForKey:@"bodyMapZoom"];
	if (bodyMapZoom == 0.0) {
		bodyMapZoom = 1.0;
	}
	self.scrollView.zoomScale = bodyMapZoom;
	
	[session addObserver:self forKeyPath:@"body.buildingMap" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	if (!session.body.buildingMap || session.body.needsSurfaceRefresh) {
		[session.body loadBuildingMap];
		self.plotsLabel.text = @"Loading";
	}
	[self->buttonsByLoc enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		[obj setNeedsDisplay];
	}];

}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	Session *session = [Session sharedInstance];
	if (session.body) {
		[session removeObserver:self forKeyPath:@"body.buildingMap"];
	}
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
	self.scrollView = nil;
	self.backgroundView = nil;
	[buttonsByLoc release];
	buttonsByLoc = nil;
	self.plotsLabel = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.scrollView = nil;
	self.backgroundView = nil;
	[buttonsByLoc release];
	buttonsByLoc = nil;
	self.plotsLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (void)switchOverlay {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL showMapOverlay = ![userDefaults boolForKey:@"showMapOverlay"];

	[UIView beginAnimations:@"page curl" context:nil];
	[buttonsByLoc enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		LEBodyMapCell *button = obj;
		button.showOverlay = showMapOverlay;
	}];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:(showMapOverlay ? UIViewAnimationTransitionCurlDown : UIViewAnimationTransitionCurlUp) forView:self.backgroundView cache:NO];
	[UIView commitAnimations];
	[self.backgroundView setNeedsDisplay];
	[userDefaults setBool:showMapOverlay forKey:@"showMapOverlay"];
	[userDefaults synchronize];
}

- (void)mapCellClicked:(LEBodyMapCell *)bodyMapCell {
	if (isNotNull(bodyMapCell.mapBuilding)) {
		ViewBuildingController *viewBuildingController = [ViewBuildingController create];
		viewBuildingController.buildingId = bodyMapCell.mapBuilding.id;
		viewBuildingController.urlPart = bodyMapCell.mapBuilding.buildingUrl;
		[self.navigationController pushViewController:viewBuildingController animated:YES];
	} else {
		NewBuildingTypeController *newBuildingTypeController = [NewBuildingTypeController create];
		newBuildingTypeController.buttonsByLoc = self->buttonsByLoc;
		newBuildingTypeController.x = bodyMapCell.buildingX;
		newBuildingTypeController.y	= bodyMapCell.buildingY;
		[self.navigationController pushViewController:newBuildingTypeController animated:YES];
	}
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.backgroundView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)inScrollView withView:(UIView *)view atScale:(double)scale {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	[userDefaults setFloat:scale forKey:@"bodyMapZoom"];
	[userDefaults synchronize];
}


#pragma mark -
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"body.buildingMap"]) {
		Session *session = [Session sharedInstance];
		UIImage *surfaceImage = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]];
		self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:surfaceImage];
		
		for (int x=BODY_BUILDINGS_MIN_X; x<=BODY_BUILDINGS_MAX_X; x++) {
			for (int y=BODY_BUILDINGS_MIN_Y; y<=BODY_BUILDINGS_MAX_Y; y++) {
				NSString *key = [NSString stringWithFormat:@"%ix%i", x, y];
				LEBodyMapCell *button = [buttonsByLoc objectForKey:key];
				MapBuilding *mapBuilding = [session.body.buildingMap objectForKey:key];
				
				if (mapBuilding) {
					button.mapBuilding = mapBuilding;
				} else {
					button.mapBuilding = nil;
				}
			}
		}
		self.plotsLabel.text = [NSString stringWithFormat:@"%@ Available", session.body.plotsAvailable];
	}
}


@end


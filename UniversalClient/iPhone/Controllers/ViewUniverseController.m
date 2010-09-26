//
//  ViewUniverseController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUniverseController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "StarMap.h"
#import "Star.h"
#import "LEUniverseCell.h"

#define MAP_CELL_SIZE 50
#define HALF_MAP_CELL_SIZE MAP_CELL_SIZE/2


@interface ViewUniverseController (PrivateMethods)

- (LEUniverseCell *)getCell;
- (void)releaseCell:(LEUniverseCell *)cell;
- (void)tileView;

@end


@implementation ViewUniverseController


@synthesize scrollView;
@synthesize map;
@synthesize inUseCells;
@synthesize reusableCells;
@synthesize starMap;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	Session *session = [Session sharedInstance];
	
	self.navigationItem.title = @"Star Map";
	if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	}
	
	if (!self.starMap) {
		self.starMap = [[[StarMap alloc] init] autorelease];
	}
	
	if (!self.reusableCells) {
		self.reusableCells = [NSMutableArray arrayWithCapacity:20];
	}
	
	if (self.inUseCells) {
		[self.inUseCells removeAllObjects];
	} else {
		self.inUseCells = [NSMutableDictionary dictionaryWithCapacity:50];
	}
	
	NSDecimalNumber *xSize;
	if ([session.universeMinX compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		xSize = [session.universeMaxX decimalNumberBySubtracting:session.universeMinX];
	} else {
		xSize = [session.universeMinX decimalNumberByAdding:session.universeMaxX];
	}
	xSize = [xSize decimalNumberByAdding:[NSDecimalNumber one]];
	NSDecimalNumber *ySize;
	if ([session.universeMinY compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		ySize = [session.universeMaxY decimalNumberBySubtracting:session.universeMinY];
	} else {
		ySize = [session.universeMinY decimalNumberByAdding:session.universeMaxY];
	}
	ySize = [ySize decimalNumberByAdding:[NSDecimalNumber one]];
	self.scrollView.contentSize = CGSizeMake(([xSize floatValue] * MAP_CELL_SIZE), ([ySize floatValue] * MAP_CELL_SIZE));
	self.scrollView.bounces = NO;
	self.scrollView.bouncesZoom = NO;
	self.scrollView.minimumZoomScale = 0.5;
	self.scrollView.maximumZoomScale = 4.0;
	
	self.map = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
	self.map.backgroundColor = [UIColor clearColor];
	self.map.autoresizesSubviews = YES;
	self.map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.scrollView addSubview:self.map];
	
	float midX = (self.scrollView.contentSize.width/2) - (self.scrollView.frame.size.width/2);
	float midY = (self.scrollView.contentSize.height/2) - (self.scrollView.frame.size.height/2);
	self.scrollView.contentOffset = CGPointMake(midX, midY);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self tileView];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.starMap addObserver:self forKeyPath:@"lastUpdate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.starMap removeObserver:self forKeyPath:@"lastUpdate"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
	[self.reusableCells removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.scrollView = nil;
	self.map = nil;
	self.inUseCells = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.scrollView = nil;
	self.map = nil;
	self.inUseCells = nil;
	self.reusableCells = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self tileView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self tileView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.map;
}


#pragma mark -
#pragma mark PrivateMethods

- (LEUniverseCell *)getCell {
	LEUniverseCell *cell;
	
	if ([self.reusableCells count] > 0) {
		cell = [self.reusableCells objectAtIndex:0];
		[self.reusableCells removeObject:cell];
	} else {
		cell = [[LEUniverseCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 225.0, 225.0)];
	}

	return cell;
}


- (void)releaseCell:(LEUniverseCell *)cell {
	[cell removeFromSuperview];
	[cell reset];
	[self.reusableCells addObject:cell];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


- (void)tileView {
	Session *session = [Session sharedInstance];
	CGRect visibleBounds = self.scrollView.bounds;
	visibleBounds = CGRectApplyAffineTransform(visibleBounds, CGAffineTransformInvert(self.map.transform));
	NSMutableArray *keysToRemove = [NSMutableArray arrayWithCapacity:10];
	
	[self.inUseCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		LEUniverseCell *cell = obj;
		if (!CGRectIntersectsRect(cell.frame, visibleBounds)) {
			[self releaseCell:cell];
			[keysToRemove addObject:key];
		}
	}];
	[keysToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self.inUseCells removeObjectForKey:obj];
	}];
    
	float minX = CGRectGetMinX(visibleBounds);
	float maxX = CGRectGetMaxX(visibleBounds);
	float minY = CGRectGetMinY(visibleBounds);
	float maxY = CGRectGetMaxY(visibleBounds);
	int minCellX = floorf(minX/MAP_CELL_SIZE);
	int maxCellX = floorf(maxX/MAP_CELL_SIZE);
	int minCellY = floorf(minY/MAP_CELL_SIZE);
	int maxCellY = floorf(maxY/MAP_CELL_SIZE);
	
	NSString *key;
	LEUniverseCell *cell;
	for (int x = minCellX; x <= maxCellX; x++) {
		for (int y = minCellY; y <= maxCellY; y++) {
			NSDecimalNumber *gridX = [[Util decimalFromInt:x] decimalNumberByAdding:session.universeMinX];
			NSDecimalNumber *gridY = [[[Util decimalFromInt:y] decimalNumberByAdding:session.universeMinY] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
			
			Star *star = [self.starMap gridX:gridX gridY:gridY];
			
			if (star) {
				key = [NSString stringWithFormat:@"%ix%i", x, y];
				cell = [self.inUseCells objectForKey:key];
				if (!cell) {
					NSLog(@"Creating cell for star %@,%@: %@", gridX, gridY, star);
					cell = [self getCell];
					[cell setStar:star];
					cell.center = CGPointMake(x*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE, y*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE);
					[self.map addSubview:cell];
					[self.inUseCells setObject:cell forKey:key];
				}
			}
		}
	}
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"lastUpdate"]) {
		[self tileView];
	}
}


@end

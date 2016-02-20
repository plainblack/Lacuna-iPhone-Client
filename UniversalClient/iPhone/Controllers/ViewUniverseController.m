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
#import "BaseMapItem.h"
#import "Body.h"
#import "Star.h"
#import "LEUniverseStarCell.h"
#import "LEUniverseBodyCell.h"
#import "UniverseGotoController.h"
#import "ViewUniverseItemController.h"

#define MAP_CELL_SIZE 50
#define HALF_MAP_CELL_SIZE MAP_CELL_SIZE/2


@interface ViewUniverseController (PrivateMethods)

- (LEUniverseBodyCell *)getBodyCellForSize:(NSInteger)size;
- (LEUniverseStarCell *)getStarCell;
- (void)releaseBodyCell:(LEUniverseBodyCell *)cell;
- (void)releaseStarCell:(LEUniverseStarCell *)cell;
- (void)tileView;

@end


@implementation ViewUniverseController


@synthesize scrollView;
@synthesize map;
@synthesize loadingView;
@synthesize inUseStarCells;
@synthesize reusableStarCells;
@synthesize inUseBodyCells;
@synthesize reusableBodyCells;
@synthesize starMap;
@synthesize gotoGridX;
@synthesize gotoGridY;


- (void)viewDidLoad {
    [super viewDidLoad];
	//NSLog(@"viewDidLoad");
	//self->updateLocation = YES;
	
	Session *session = [Session sharedInstance];
	
	self.navigationItem.title = @"Star Map";
	if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)] autorelease];
	}
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Go To" style:UIBarButtonItemStylePlain target:self action:@selector(showGotoPage)] autorelease];
	
	if (!self.starMap) {
		self.starMap = [[[StarMap alloc] init] autorelease];
		self->isUpdating = NO;
	}
	
	if (!self.reusableStarCells) {
		self.reusableStarCells = [NSMutableArray arrayWithCapacity:5];
	}
	
	if (self.inUseStarCells) {
		[self.inUseStarCells removeAllObjects];
	} else {
		self.inUseStarCells = [NSMutableDictionary dictionaryWithCapacity:5];
	}
	
	if (!self.reusableBodyCells) {
		self.reusableBodyCells = [NSMutableArray arrayWithCapacity:10];
	}
	
	if (self.inUseBodyCells) {
		[self.inUseBodyCells removeAllObjects];
	} else {
		self.inUseBodyCells = [NSMutableDictionary dictionaryWithCapacity:20];
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
	
	self.map = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)] autorelease];
	self.map.autoresizesSubviews = YES;
	self.map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[self.scrollView addSubview:self.map];
	
	[self.loadingView removeFromSuperview];
	[self.view addSubview:self.loadingView];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (self.gotoGridX && self.gotoGridY) {
		[self gotoGridX:self.gotoGridX gridY:self.gotoGridY];
		self.gotoGridX = nil;
		self.gotoGridY = nil;
	}

	[self tileView];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.starMap addObserver:self forKeyPath:@"lastUpdate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.starMap addObserver:self forKeyPath:@"numLoading" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (self.starMap.numLoading > 0) {
		[self.loadingView startAnimating];
	}
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.loadingView stopAnimating];
	[self.starMap removeObserver:self forKeyPath:@"lastUpdate"];
	[self.starMap removeObserver:self forKeyPath:@"numLoading"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
	[self.reusableStarCells removeAllObjects];
	[self.reusableBodyCells removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.scrollView = nil;
	self.map = nil;
	self.loadingView = nil;
	self.inUseStarCells = nil;
	self.inUseBodyCells = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.scrollView = nil;
	self.map = nil;
	self.loadingView = nil;
	self.inUseStarCells = nil;
	self.reusableStarCells = nil;
	self.inUseBodyCells = nil;
	self.reusableBodyCells = nil;
	self.gotoGridX = nil;
	self.gotoGridY = nil;
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

- (LEUniverseStarCell *)getStarCell {
	LEUniverseStarCell *cell = nil;
	
	if ([self.reusableStarCells count] > 0) {
		cell = [self.reusableStarCells objectAtIndex:0];
		[[cell retain] autorelease];
		[self.reusableStarCells removeObject:cell];
	} else {
		cell = [[[LEUniverseStarCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 150)] autorelease];
	}

	[cell setTarget:self callback:@selector(starPressed:)];

	return cell;
}


- (void)releaseStarCell:(LEUniverseStarCell *)cell {
	[cell removeFromSuperview];
	[cell reset];
	[self.reusableStarCells addObject:cell];
}


- (LEUniverseBodyCell *)getBodyCellForSize:(NSInteger)size {
	LEUniverseBodyCell *cell;
	CGFloat computedSize = ( (100.0 - ABS(size - 100.0)) / (100.0 / 50.0) ) + 15.0;
	
	if ([self.reusableBodyCells count] > 0) {
		cell = [self.reusableBodyCells objectAtIndex:0];
		[[cell retain] autorelease];
		[self.reusableBodyCells removeObject:cell];
		cell.frame = CGRectMake(0.0, 0.0, computedSize, computedSize);
	} else {
		cell = [[[LEUniverseBodyCell alloc] initWithFrame:CGRectMake(0.0, 0.0, computedSize, computedSize)] autorelease];
	}
	
	[cell setTarget:self callback:@selector(bodyPressed:)];
	
	return cell;
}


- (void)releaseBodyCell:(LEUniverseBodyCell *)cell {
	[cell removeFromSuperview];
	[cell reset];
	[self.reusableBodyCells addObject:cell];
}


#pragma mark -
#pragma mark UniverseGotoControllerDelegate Methods

- (void)selectedGridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *) gridY {
	[self.navigationController popViewControllerAnimated:YES];
	[self gotoGridX:gridX gridY:gridY];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


- (IBAction)showGotoPage {
	UniverseGotoController *universeGotoController = [UniverseGotoController create];
	universeGotoController.delegate = self;
	[self.navigationController pushViewController:universeGotoController animated:YES];
}

- (void)clear {
	[self.starMap clearMap];
	[self.inUseBodyCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		[obj removeFromSuperview];
	}];
	[self.inUseBodyCells removeAllObjects];
	[self.reusableBodyCells removeAllObjects];
	[self.inUseStarCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		[obj removeFromSuperview];
	}];
	[self.inUseStarCells removeAllObjects];
	[self.reusableStarCells removeAllObjects];
	self.gotoGridX = nil;
	self.gotoGridY = nil;
}


- (void)gotoGridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY {
	Session *session = [Session sharedInstance];
	NSDecimalNumber *cellX = [gridX decimalNumberBySubtracting:session.universeMinX];
	NSDecimalNumber *cellY = [[gridY decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]] decimalNumberBySubtracting:session.universeMinY];
	
	NSDecimalNumber *tmpX = [cellX decimalNumberByMultiplyingBy:[Util decimalFromInt:MAP_CELL_SIZE]];
	NSDecimalNumber *tmpY = [cellY decimalNumberByMultiplyingBy:[Util decimalFromInt:MAP_CELL_SIZE]];
	
	CGFloat topLeftX = [tmpX floatValue] - (self.scrollView.frame.size.width/2) + HALF_MAP_CELL_SIZE;
	CGFloat topLeftY = [tmpY floatValue] - (self.scrollView.frame.size.height/2) + HALF_MAP_CELL_SIZE;
	
	CGRect scrollToRect = CGRectMake(topLeftX, topLeftY, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	[self.scrollView scrollRectToVisible:scrollToRect animated:NO];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)tileView {
	Session *session = [Session sharedInstance];
	CGRect visibleBounds = self.scrollView.bounds;
	visibleBounds = CGRectApplyAffineTransform(visibleBounds, CGAffineTransformInvert(self.map.transform));
	NSMutableArray *keysToRemove = [NSMutableArray arrayWithCapacity:10];
	
	[self.inUseStarCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		LEUniverseStarCell *cell = obj;
		if (!CGRectIntersectsRect(cell.frame, visibleBounds)) {
			[self releaseStarCell:cell];
			[keysToRemove addObject:key];
		}
	}];
	[keysToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self.inUseStarCells removeObjectForKey:obj];
	}];

	[self.inUseBodyCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		LEUniverseBodyCell *cell = obj;
		if (!CGRectIntersectsRect(cell.frame, visibleBounds)) {
			[self releaseBodyCell:cell];
			[keysToRemove addObject:key];
		}
	}];
	[keysToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self.inUseBodyCells removeObjectForKey:obj];
	}];
	
	float minX = CGRectGetMinX(visibleBounds);
	float maxX = CGRectGetMaxX(visibleBounds);
	float minY = CGRectGetMinY(visibleBounds);
	float maxY = CGRectGetMaxY(visibleBounds);
	int minCellX = floorf(minX/MAP_CELL_SIZE);
	int maxCellX = floorf(maxX/MAP_CELL_SIZE);
	int minCellY = floorf(minY/MAP_CELL_SIZE);
	int maxCellY = floorf(maxY/MAP_CELL_SIZE);
	
	for (int x = minCellX; x <= maxCellX; x++) {
		for (int y = minCellY; y <= maxCellY; y++) {
			NSDecimalNumber *gridX = [[Util decimalFromInt:x] decimalNumberByAdding:session.universeMinX];
			NSDecimalNumber *gridY = [[[Util decimalFromInt:y] decimalNumberByAdding:session.universeMinY] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
			
			BaseMapItem *item = [self.starMap gridX:gridX gridY:gridY];
			
			if (item) {
				NSString *key = [NSString stringWithFormat:@"%ix%i", x, y];
				if ([item.type isEqualToString:@"star"]) {
					Star *star = (Star *)item;
					LEUniverseStarCell *cell = [self.inUseStarCells objectForKey:key];
					if (!cell) {
						cell = [self getStarCell];
						[cell setStar:star];
						cell.center = CGPointMake(x*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE, y*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE);
						[self.map addSubview:cell];
						[self.inUseStarCells setObject:cell forKey:key];
					}
				} else {
					Body *body = (Body *)item;
					LEUniverseBodyCell *cell = [self.inUseBodyCells objectForKey:key];
					if (!cell) {
						cell = [self getBodyCellForSize:_intv(body.size)];
						[cell setBody:body];
						cell.center = CGPointMake(x*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE, y*MAP_CELL_SIZE + HALF_MAP_CELL_SIZE);
						[self.map addSubview:cell];
						[self.inUseBodyCells setObject:cell forKey:key];
					}
				}
			}
		}
	}
}


#pragma mark -
#pragma mark Callback Methods

- (void)bodyPressed:(LEUniverseBodyCell *)cell {
	if (!self->isUpdating) {
		self->isUpdating = YES;
		[self.starMap updateStar:cell.body.starId target:self callback:@selector(doneUpdatingStar:)];
		ViewUniverseItemController *viewUniverseItemController = [ViewUniverseItemController create];
		viewUniverseItemController.mapItem = cell.body;
		[self.navigationController pushViewController:viewUniverseItemController animated:YES];
	}
}


- (void)starPressed:(LEUniverseStarCell *)cell {
	if (!self->isUpdating) {
		self->isUpdating = YES;
		[self.starMap updateStar:cell.star.id target:self callback:@selector(showStar:)];
	}
}


- (void)showStar:(Star *)star {
	self->isUpdating = NO;
	ViewUniverseItemController *viewUniverseItemController = [ViewUniverseItemController create];
	viewUniverseItemController.mapItem = star;
	[self.navigationController pushViewController:viewUniverseItemController animated:YES];
}


- (void)doneUpdatingStar:(Star *)star {
	self->isUpdating = NO;
}

#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"lastUpdate"]) {
		[self tileView];
	} else if ([keyPath isEqual:@"numLoading"]) {
		if (self.starMap.numLoading > 0 && ![self.loadingView isAnimating]) {
			[self.loadingView startAnimating];
		} else if (self.starMap.numLoading <= 0 && [self.loadingView isAnimating]) {
			[self.loadingView stopAnimating];
		}
	}
}


@end

//
//  LEBodyMapCell.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBodyMapCell.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Body.h"
#import "MapBuilding.h"

#define LEVEL_FONT [UIFont fontWithName:@"Verdana-Bold" size:28.0]
#define TIME_FONT [UIFont fontWithName:@"Verdana-Bold" size:12.0]


@implementation LEBodyMapCell


@synthesize showOverlay;
@synthesize buildingX;
@synthesize buildingY;
@synthesize mapBuilding;


#pragma mark -
#pragma mark NSObject Methods

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
		self.showOverlay = NO;
		UITapGestureRecognizer *tmp = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] autorelease];
		[self addGestureRecognizer:tmp];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    //Draw Building Image
	if (self.mapBuilding) {
		[self.mapBuilding.image drawInRect:self.bounds];
		
		if (self.showOverlay) {
			
			[[UIColor whiteColor] setFill];

			//Draw buildTime
			if (self.mapBuilding.pendingBuild) {
				[[Util prettyDuration:self.mapBuilding.pendingBuild.secondsRemaining] drawInRect:CGRectMake(5.0, 0.0, 90.0, 15.0) withFont:TIME_FONT lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
			}
			
			//Draw workTime
			if (self.mapBuilding.work) {
				[WARNING_COLOR setFill];
				[[Util prettyDuration:self.mapBuilding.work.secondsRemaining] drawInRect:CGRectMake(5.0, 20.0, 90.0, 15.0) withFont:TIME_FONT lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
				[[UIColor whiteColor] setFill];
			}
			
			//Draw level
			[[self.mapBuilding.level stringValue] drawInRect:CGRectMake(30.0, 40.0, 40.0, 20.0) withFont:LEVEL_FONT lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
			
			//Draw Efficiency
			NSInteger efficency = [self.mapBuilding.efficiency intValue];
			if (efficency != 100) {
				UIColor *colorToUse;
				if (efficency >= 75) {
					colorToUse = [UIColor greenColor];
				} else if (efficency >= 50) {
					colorToUse = [UIColor yellowColor];
				} else {
					colorToUse = [UIColor redColor];
				}
				
				[colorToUse setFill];
				[colorToUse setStroke];
				CGContextRef ctx = UIGraphicsGetCurrentContext();
				
				//Draw outline
				CGRect barOutline = CGRectMake(5.0, 85.0, 90.0, 10.0);
				CGContextStrokeRectWithWidth(ctx, barOutline, 2.0);
				
				//Fill bar segment
				CGRect barFillSegment = CGRectMake(5.0, 85.0, (efficency/100.0 * 90.0), 10.0);
				CGContextFillRect(ctx, barFillSegment);
			}
		}
	} else {
		[[UIImage imageNamed:@"/assets/planet_side/build.png"] drawInRect:self.bounds];
	}

}


- (void)dealloc {
	self.buildingX = nil;
	self.buildingY = nil;
	self.mapBuilding = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark setters

- (void)setShowOverlay:(BOOL)showOverlayValue {
	if (showOverlayValue != self->showOverlay) {
		self->showOverlay = showOverlayValue;
		[self setNeedsDisplay];
	}
}


- (void)setMapBuilding:(MapBuilding *)mapBuildingValue {
	if (mapBuildingValue != self->mapBuilding) {

		//Adjust retain/release
		[mapBuildingValue retain];
		
		//Adjust KVO targets
		[self->mapBuilding removeObserver:self forKeyPath:@"needsRefresh"];
		[mapBuildingValue addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

		//Adjust retain/release
		[self->mapBuilding release];

		self->mapBuilding = mapBuildingValue;
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Instance Methods

- (void)target:(id)inTarget callback:(SEL)inCallback {
	self->target = inTarget;
	self->callback = inCallback;
}


#pragma mark -
#pragma mark Action Methods

- (void)tapped {
	if (self->target && self->callback) {
		[self->target performSelector:self->callback withObject:self];
	}
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsRefresh"]) {
		[self setNeedsDisplay];
	}
}


@end

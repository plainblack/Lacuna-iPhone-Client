//
//  LETableViewCellProgress.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellProgress.h"
#import "Util.h"
#import "LEMacros.h"


@implementation LETableViewCellProgress


@synthesize progressView;
@synthesize secondsLabel;
@synthesize delegate;
@synthesize timer;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[self.timer invalidate];
	self.timer = nil;
	self.progressView = nil;
	self.secondsLabel = nil;
	self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setTotalTime:(NSInteger)inTotalTime remainingTime:(NSInteger)inRemainingTime {
	NSLog(@"totalTime: %i, remainingTime: %i", inTotalTime, inRemainingTime);
	totalTime = inTotalTime + 2;
	remainingTime = inRemainingTime + 2;
	[self handleTimer:nil];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}


- (void)handleTimer:(NSTimer *)theTimer {
	remainingTime--;
	if (remainingTime > 0){
		CGFloat progress = (totalTime - (float)remainingTime) / totalTime;
		self.progressView.progress = progress;
		self.secondsLabel.text = [Util prettyDuration:remainingTime];
	} else {
		self.progressView.progress = 1.0;
		[self.timer invalidate];
		self.timer = nil;
		[delegate progressComplete];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellProgress *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"PreogressCell";
	
	LETableViewCellProgress *cell = (LETableViewCellProgress *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellProgress alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
		cell.progressView.frame = CGRectMake(20, 11, 280, 9);
		cell.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.progressView];
		
		cell.secondsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 22, 280, 21)] autorelease];
		cell.secondsLabel.backgroundColor = [UIColor clearColor];
		cell.secondsLabel.textAlignment = UITextAlignmentCenter;
		cell.secondsLabel.font = TEXT_SMALL_FONT;
		cell.secondsLabel.textColor = TEXT_SMALL_COLOR;
		cell.secondsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.secondsLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 50.0;
}


@end

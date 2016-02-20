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
@synthesize timedActivity;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Does nothing for now
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	self.progressView = nil;
	self.secondsLabel = nil;
	self.timedActivity = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)bindToTimedActivity:(TimedActivity *)inTimedActivity {
	self.timedActivity = inTimedActivity;
	if (self.timedActivity.secondsRemaining > 0){
		self.progressView.progress = [self.timedActivity progress];
		self.secondsLabel.text = [Util prettyDuration:self.timedActivity.secondsRemaining];
	} else {
		self.progressView.progress = 1.0;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellProgress *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"PreogressCell";
	
	LETableViewCellProgress *cell = (LETableViewCellProgress *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellProgress alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
		cell.progressView.frame = CGRectMake(20, 11, 280, 9);
		cell.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.progressView];
		
		cell.secondsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 22, 280, 21)] autorelease];
		cell.secondsLabel.backgroundColor = [UIColor clearColor];
		cell.secondsLabel.textAlignment = NSTextAlignmentCenter;
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

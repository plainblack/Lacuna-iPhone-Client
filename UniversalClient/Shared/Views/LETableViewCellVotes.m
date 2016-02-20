//
//  LETableViewCellVotes.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/22/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LETableViewCellVotes.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellVotes

@synthesize votesNeededLabel;
@synthesize votesForLabel;
@synthesize votesAgainstLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    self.votesNeededLabel = nil;
    self.votesForLabel = nil;
    self.votesAgainstLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setVotesNeeded:(NSDecimalNumber *)votesNeeded votesFor:(NSDecimalNumber *)votesFor votesAgainst:(NSDecimalNumber *)votesAgainst {
    self.votesNeededLabel.text = [Util prettyNSDecimalNumber:votesNeeded];
    self.votesForLabel.text = [Util prettyNSDecimalNumber:votesFor];
    self.votesAgainstLabel.text = [Util prettyNSDecimalNumber:votesAgainst];
}


#pragma mark -
#pragma mark Class methods

+ (LETableViewCellVotes *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"VotesCell";
	NSInteger y = 5;
	
	LETableViewCellVotes *cell = (LETableViewCellVotes *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellVotes alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;

		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 95, 44)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Votes";
		[cell.contentView addSubview:tmpLabel];
        
        
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Needed";
		[cell.contentView addSubview:tmpLabel];
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"For";
		[cell.contentView addSubview:tmpLabel];
        
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, y, 50, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = NSTextAlignmentCenter;
		tmpLabel.font = LABEL_SMALL_FONT;
		tmpLabel.textColor = LABEL_SMALL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Against";
		[cell.contentView addSubview:tmpLabel];
        
		y += 15;
		cell.votesNeededLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, y, 50, 20)] autorelease];
		cell.votesNeededLabel.backgroundColor = [UIColor clearColor];
		cell.votesNeededLabel.textAlignment = NSTextAlignmentCenter;
		cell.votesNeededLabel.font = TEXT_SMALL_FONT;
		cell.votesNeededLabel.textColor = TEXT_SMALL_COLOR;
		cell.votesNeededLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.votesNeededLabel];
		
		cell.votesForLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, y, 50, 20)] autorelease];
		cell.votesForLabel.backgroundColor = [UIColor clearColor];
		cell.votesForLabel.textAlignment = NSTextAlignmentCenter;
		cell.votesForLabel.font = TEXT_SMALL_FONT;
		cell.votesForLabel.textColor = TEXT_SMALL_COLOR;
		cell.votesForLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.votesForLabel];
		
		cell.votesAgainstLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, y, 50, 20)] autorelease];
		cell.votesAgainstLabel.backgroundColor = [UIColor clearColor];
		cell.votesAgainstLabel.textAlignment = NSTextAlignmentCenter;
		cell.votesAgainstLabel.font = TEXT_SMALL_FONT;
		cell.votesAgainstLabel.textColor = TEXT_SMALL_COLOR;
		cell.votesAgainstLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.votesAgainstLabel];
		
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
        
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 45.0;
}


@end

//
//  LETableViewCellMailHeaders.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellMailHeaders.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellMailHeaders


@synthesize subjectText;
@synthesize toLabel;
@synthesize toText;
@synthesize fromLabel;
@synthesize fromText;
@synthesize dateLabel;
@synthesize dateText;


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
	self.subjectText = nil;
	self.toLabel = nil;
	self.toText = nil;
	self.fromLabel = nil;
	self.fromText = nil;
	self.dateLabel = nil;
	self.dateText = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setMessage:(NSDictionary *)message {
	self.subjectText.text = [message objectForKey:@"subject"];
	self.toText.text = [message objectForKey:@"to"];
	self.fromText.text = [message objectForKey:@"from"];
	self.dateText.text = [Util prettyDate:[message objectForKey:@"date"]];

	UIColor *color;
	if (_intv([message objectForKey:@"has_read"])) {
		color = TEXT_COLOR;
	} else {
		color = UNREAD_MAIL_TEXT_COLOR;
	}
	self.subjectText.textColor = color;
	self.toText.textColor = color;
	self.fromText.textColor = color;
	self.dateText.textColor = color;
	
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellMailHeaders *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"MailHeadersCell";
	
	LETableViewCellMailHeaders *cell = (LETableViewCellMailHeaders *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellMailHeaders alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.subjectText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.subjectText.backgroundColor = [UIColor clearColor];
		cell.subjectText.textAlignment = NSTextAlignmentLeft;
		cell.subjectText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.subjectText.font = TEXT_FONT;
		cell.subjectText.textColor = MAIL_TEXT_COLOR;
		[cell.contentView addSubview:cell.subjectText];
		
		cell.toLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 50, 15)] autorelease];
		cell.toLabel.backgroundColor = [UIColor clearColor];
		cell.toLabel.textAlignment = NSTextAlignmentRight;
		cell.toLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.toLabel.font = LABEL_SMALL_FONT;
		cell.toLabel.textColor = LABEL_COLOR;
		cell.toLabel.text = @"to:";
		[cell.contentView addSubview:cell.toLabel];
		cell.toText = [[[UILabel alloc] initWithFrame:CGRectMake(55, 25, 265, 15)] autorelease];
		cell.toText.backgroundColor = [UIColor clearColor];
		cell.toText.textAlignment = NSTextAlignmentLeft;
		cell.toText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.toText.font = LABEL_FONT;
		cell.toText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.toText];
		
		cell.fromLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 50, 15)] autorelease];
		cell.fromLabel.backgroundColor = [UIColor clearColor];
		cell.fromLabel.textAlignment = NSTextAlignmentRight;
		cell.fromLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.fromLabel.font = LABEL_SMALL_FONT;
		cell.fromLabel.textColor = MAIL_TEXT_COLOR;
		cell.fromLabel.text = @"from:";
		[cell.contentView addSubview:cell.fromLabel];
		cell.fromText = [[[UILabel alloc] initWithFrame:CGRectMake(55, 40, 265, 15)] autorelease];
		cell.fromText.backgroundColor = [UIColor clearColor];
		cell.fromText.textAlignment = NSTextAlignmentLeft;
		cell.fromText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.fromText.font = LABEL_FONT;
		cell.fromText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.fromText];
		
		cell.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 55, 50, 15)] autorelease];
		cell.dateLabel.backgroundColor = [UIColor clearColor];
		cell.dateLabel.textAlignment = NSTextAlignmentRight;
		cell.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.dateLabel.font = LABEL_SMALL_FONT;
		cell.dateLabel.textColor = MAIL_TEXT_COLOR;
		cell.dateLabel.text = @"sent:";
		[cell.contentView addSubview:cell.dateLabel];
		cell.dateText = [[[UILabel alloc] initWithFrame:CGRectMake(55, 55, 265, 15)] autorelease];
		cell.dateText.backgroundColor = [UIColor clearColor];
		cell.dateText.textAlignment = NSTextAlignmentLeft;
		cell.dateText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.dateText.font = LABEL_FONT;
		cell.dateText.textColor = TEXT_COLOR;
		[cell.contentView addSubview:cell.dateText];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 75.0;
}


@end

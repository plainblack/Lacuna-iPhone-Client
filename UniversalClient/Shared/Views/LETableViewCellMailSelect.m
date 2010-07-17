//
//  LETableViewCellMailSelect.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellMailSelect.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellMailSelect


@synthesize subjectText;
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
	self.fromText.text = [message objectForKey:@"from"];
	self.dateText.text = [Util prettyDate:[message objectForKey:@"date"]];
	
	if (_intv([message objectForKey:@"has_read"])) {
		self.subjectText.textColor = MAIL_TEXT_COLOR;
		self.fromLabel.textColor = MAIL_TEXT_COLOR;
		self.fromText.textColor = MAIL_TEXT_COLOR;
		self.dateLabel.textColor = MAIL_TEXT_COLOR;
		self.dateText.textColor = MAIL_TEXT_COLOR;
	} else {
		self.subjectText.textColor = UNREAD_MAIL_TEXT_COLOR;
		self.fromLabel.textColor = UNREAD_MAIL_TEXT_COLOR;
		self.fromText.textColor = UNREAD_MAIL_TEXT_COLOR;
		self.dateLabel.textColor = UNREAD_MAIL_TEXT_COLOR;
		self.dateText.textColor = UNREAD_MAIL_TEXT_COLOR;
	}

}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellMailSelect *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"LabeledTextCell";
	
	LETableViewCellMailSelect *cell = (LETableViewCellMailSelect *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellMailSelect alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.subjectText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.subjectText.backgroundColor = [UIColor clearColor];
		cell.subjectText.textAlignment = UITextAlignmentLeft;
		cell.subjectText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.subjectText.font = TEXT_FONT;
		cell.subjectText.textColor = MAIL_TEXT_COLOR;
		[cell.contentView addSubview:cell.subjectText];
		
		cell.fromLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 40, 15)] autorelease];
		cell.fromLabel.backgroundColor = [UIColor clearColor];
		cell.fromLabel.textAlignment = UITextAlignmentRight;
		cell.fromLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.fromLabel.font = LABEL_FONT;
		cell.fromLabel.textColor = MAIL_TEXT_COLOR;
		cell.fromLabel.text = @"from:";
		[cell.contentView addSubview:cell.fromLabel];
		cell.fromText = [[[UILabel alloc] initWithFrame:CGRectMake(50, 25, 310, 15)] autorelease];
		cell.fromText.backgroundColor = [UIColor clearColor];
		cell.fromText.textAlignment = UITextAlignmentLeft;
		cell.fromText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.fromText.font = LABEL_FONT;
		cell.fromText.textColor = MAIL_TEXT_COLOR;
		[cell.contentView addSubview:cell.fromText];
		
		cell.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 40, 15)] autorelease];
		cell.dateLabel.backgroundColor = [UIColor clearColor];
		cell.dateLabel.textAlignment = UITextAlignmentRight;
		cell.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.dateLabel.font = LABEL_FONT;
		cell.dateLabel.textColor = MAIL_TEXT_COLOR;
		cell.dateLabel.text = @"sent:";
		[cell.contentView addSubview:cell.dateLabel];
		cell.dateText = [[[UILabel alloc] initWithFrame:CGRectMake(50, 40, 310, 15)] autorelease];
		cell.dateText.backgroundColor = [UIColor clearColor];
		cell.dateText.textAlignment = UITextAlignmentLeft;
		cell.dateText.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.dateText.font = LABEL_FONT;
		cell.dateText.textColor = MAIL_TEXT_COLOR;
		[cell.contentView addSubview:cell.dateText];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 60.0;
}


@end

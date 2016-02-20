//
//  LETableViewCellBattleReport.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LETableViewCellBattleReport.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


typedef enum {
    LEVEL_1,
    LEVEL_2,
} LABEL_LEVEL;


@interface LETableViewCellBattleReport (PrivateMethods)

- (UILabel *)setupLabels:(NSString *)name level:(LABEL_LEVEL)level y:(CGFloat)y;

@end


@implementation LETableViewCellBattleReport


@synthesize dateLabel;
@synthesize attackerNameLabel;
@synthesize attackerFromLabel;
@synthesize attackerUnitLabel;
@synthesize defenderNameLabel;
@synthesize defenderFromLabel;
@synthesize defenderUnitLabel;
@synthesize victorLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = CELL_BACKGROUND_COLOR;
		self.autoresizesSubviews = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

        self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 310.0, 20.0)] autorelease];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.font = BUTTON_TEXT_FONT;
        self.dateLabel.textColor = BUTTON_TEXT_COLOR;
        self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.dateLabel];

        self.attackerNameLabel = [self setupLabels:@"Attacker" level:LEVEL_1 y:30.0];
        self.attackerFromLabel = [self setupLabels:@"From" level:LEVEL_2 y:50.0];
        self.attackerUnitLabel = [self setupLabels:@"With" level:LEVEL_2 y:65.0];
		
        self.defenderNameLabel = [self setupLabels:@"Defender" level:LEVEL_1 y:85.0];
        self.defenderFromLabel = [self setupLabels:@"From" level:LEVEL_2 y:105.0];
        self.defenderUnitLabel = [self setupLabels:@"With" level:LEVEL_2 y:120.0];
		
        self.victorLabel = [self setupLabels:@"Victor" level:LEVEL_1 y:140.0];
    }
    return self;
}


- (UILabel *)setupLabels:(NSString *)name level:(LABEL_LEVEL)level y:(CGFloat)y {
    CGFloat height = 0.0;
    UIFont *font = nil;
    
    switch (level) {
        case LEVEL_1:
            height = 20.0;
            font = TEXT_FONT;
            break;
        case LEVEL_2:
            height = 15.0;
            font = TEXT_SMALL_FONT;
            break;
    }

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, y, 100.0, height)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = font;
    nameLabel.textColor = LABEL_COLOR;
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    nameLabel.text = name;
    [self addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, y, 200.0, height)];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.textAlignment = NSTextAlignmentLeft;
    dataLabel.font = font;
    dataLabel.textColor = TEXT_COLOR;
    dataLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:dataLabel];
    [dataLabel release];

    return dataLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)dealloc {
    self.dateLabel  = nil;
	self.attackerNameLabel = nil;
	self.attackerFromLabel = nil;
	self.attackerUnitLabel = nil;
	self.defenderNameLabel = nil;
	self.defenderFromLabel = nil;
	self.defenderUnitLabel = nil;
    self.victorLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setBattleLog:(NSMutableDictionary *)battleLog {
    Session *session = [Session sharedInstance];
    
    self.dateLabel.text = [NSString stringWithFormat:@"At %@", [Util prettyDate:[battleLog objectForKey:@"date"]]];
    if ([[battleLog objectForKey:@"attacking_empire"] isEqual:[NSDecimalNumber zero]]) {
        self.attackerNameLabel.text = [battleLog objectForKey:@"attacking_empire"];
    } else {
        self.attackerNameLabel.text = session.empire.name;
    }
    self.attackerFromLabel.text = [battleLog objectForKey:@"attacking_body"];
    self.attackerUnitLabel.text = [battleLog objectForKey:@"attacking_unit"];
    if ([[battleLog objectForKey:@"defending_empire"] isEqual:[NSDecimalNumber zero]]) {
        self.defenderNameLabel.text = [battleLog objectForKey:@"defending_empire"];
    } else {
        self.defenderNameLabel.text = session.empire.name;
    }
    self.defenderFromLabel.text = [battleLog objectForKey:@"defending_body"];
    if (isNotEmptyString([battleLog objectForKey:@"defending_unit"])) {
        self.defenderUnitLabel.text = [battleLog objectForKey:@"defending_unit"];
    } else {
        self.defenderUnitLabel.text = @"Nothing";
    }
    self.victorLabel.text = [[battleLog objectForKey:@"victory_to"] capitalizedString];
}


#pragma mark -
#pragma mark Private Methods


- (void)setCostLabel:(UILabel *)costLabel cost:(NSDecimalNumber *)cost {
	costLabel.text = [NSString stringWithFormat:@"%@", [Util prettyNSDecimalNumber:cost]];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBattleReport *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"LETableViewCellBattleReport";
	
	LETableViewCellBattleReport *cell = (LETableViewCellBattleReport *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[LETableViewCellBattleReport alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 170.0;
}


@end

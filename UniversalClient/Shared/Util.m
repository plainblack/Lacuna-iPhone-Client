//
//  Util.m
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Util.h"


@implementation Util

+ (CGFloat)heightForText:(NSString *)text inFrame:(CGRect)frame withFont:(UIFont *)font {
	if (!text || (id)text == [NSNull null]) {
		text = @"";
	}
	// NOTE: FLT_MAX is a large float. Returned height will be less.
	CGSize cellSize = CGSizeMake(frame.size.width - 10, FLT_MAX);
	cellSize = [text sizeWithFont:font 
				   constrainedToSize:cellSize
					   lineBreakMode:UILineBreakModeWordWrap];
	return cellSize.height + 10;
}


+ (NSDate *)date:(NSString *)serverDateString {
	NSDateFormatter *serverDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[serverDateFormatter setDateFormat:@"dd MM yyyy HH:mm:ss ZZZ"];
	return [serverDateFormatter dateFromString:serverDateString];
}


+ (NSString *)formatDate:(NSDate *)serverDate {
	NSDateFormatter *localDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[localDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	return [localDateFormatter stringFromDate:serverDate];
}


+ (NSString *)prettyDate:(NSString *)serverDateString {
	return [Util formatDate:[Util date:serverDateString]];
}


+ (NSNumber *)asNumber:(NSString *)string {
	NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	return [f numberFromString:string];
}


+ (NSString *)prettyDuration:(NSInteger)seconds {
	NSInteger minutes = seconds / 60;
	seconds = seconds % 60;
	NSInteger hours = minutes / 60;
	minutes = minutes % 60;
	NSInteger days = hours / 24;
	hours = hours %24;
	
	if (days) {
		return [NSString stringWithFormat:@"%iD, %02i:%02i:%02i", days, hours, minutes, seconds];
	} else {
		return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
	}
}


+ (NSString *)prettyNSNumber:(NSNumber *)number {
	return [self prettyNSInteger:[number intValue]];
}


+ (NSString *)prettyNSInteger:(NSInteger)number {
	if (number >= 10000000000) {
		return [NSString stringWithFormat:@"%iB", (number/1000000000)];
	} else if (number >= 10000000) {
		return [NSString stringWithFormat:@"%iM", (number/1000000)];
	} else if (number >= 10000) {
		return [NSString stringWithFormat:@"%iK", (number/1000)];
	} else {
		return [NSString stringWithFormat:@"%i", number];
	}
}


+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end

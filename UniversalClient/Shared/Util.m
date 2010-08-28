//
//  Util.m
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Util.h"
#import "LEMacros.h"

static NSDecimalNumber *NEGATIVE_ONE;
static NSDecimalNumber *ONE_THOUSAND;
static NSDecimalNumber *TEN_THOUSAND;
static NSDecimalNumber *ONE_HUNDRED_THOUSAND;
static NSDecimalNumber *ONE_MILLION;
static NSDecimalNumber *TEN_MILLION;
static NSDecimalNumber *ONE_HUNDRED_MILLION;
static NSDecimalNumber *ONE_BILLION;
static NSDecimalNumber *TEN_BILLION;
static NSDecimalNumber *ONE_HUNDRED_BILLION;

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


+ (NSInteger)numPagesForCount:(NSInteger)count {
	NSInteger tmp = count / ITEMS_PER_PAGE;
	if (count % ITEMS_PER_PAGE > 0) {
		tmp++;
	}
	return tmp;
}


+ (NSString *)idFromDict:(NSDictionary *)dict named:(NSString *)name {
	id obj = [dict objectForKey:name];
	if ([obj respondsToSelector:@selector(stringValue)]) {
		return [obj stringValue];
	} else {
		return (NSString *)obj;
	}

}


+ (NSDecimalNumber *)decimalFromInt:(NSInteger)inNumber {
	return (NSDecimalNumber *)[NSDecimalNumber numberWithInt:inNumber];
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


+ (NSDecimalNumber *)asNumber:(id)obj {
	NSDecimalNumber *result;
	
	if (isNotNull(obj)) {
		if ([obj isKindOfClass:[NSDecimalNumber class]]) {
			result = obj;
		}else if ([obj isKindOfClass:[NSString class]]) {
			result = [NSDecimalNumber decimalNumberWithString:obj];
		} else {
			NSLog(@"OMG WTF DO WE DO WITH THIS!");
			NSLog(@"Value: %@(%@)", obj, [obj class]);
			result = nil;
		}
	} else {
		result = nil;
	}

	return result;
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


+ (NSString *)prettyNSDecimalNumber:(NSDecimalNumber *)number {
	if (!ONE_THOUSAND) {
		NEGATIVE_ONE = [[NSDecimalNumber decimalNumberWithString:@"-1"] retain];
		ONE_THOUSAND = [[NSDecimalNumber decimalNumberWithString:@"1000"] retain];
		TEN_THOUSAND = [[NSDecimalNumber decimalNumberWithString:@"10000"] retain];
		ONE_HUNDRED_THOUSAND = [[NSDecimalNumber decimalNumberWithString:@"100000"] retain];
		ONE_MILLION = [[NSDecimalNumber decimalNumberWithString:@"1000000"] retain];
		TEN_MILLION = [[NSDecimalNumber decimalNumberWithString:@"10000000"] retain];
		ONE_HUNDRED_MILLION = [[NSDecimalNumber decimalNumberWithString:@"100000000"] retain];
		ONE_BILLION = [[NSDecimalNumber decimalNumberWithString:@"1000000000"] retain];
		TEN_BILLION = [[NSDecimalNumber decimalNumberWithString:@"10000000000"] retain];
		ONE_HUNDRED_BILLION = [[NSDecimalNumber decimalNumberWithString:@"100000000000"] retain];
	}

	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setUsesSignificantDigits:YES];
	[formatter setMaximumSignificantDigits:3];
	[formatter setMinimumSignificantDigits:3];
	NSDecimalNumber *compareNumber;
	
	if ([number compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		compareNumber = [number decimalNumberByMultiplyingBy:NEGATIVE_ONE];
	} else	{
		compareNumber = number;
	}
	
	if ([compareNumber compare:ONE_HUNDRED_BILLION] == NSOrderedDescending || [compareNumber compare:ONE_HUNDRED_BILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@B", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_BILLION]]];
	} else if ([compareNumber compare:TEN_BILLION] == NSOrderedDescending || [compareNumber compare:TEN_BILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@B", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_BILLION]]];
	} else if ([compareNumber compare:ONE_BILLION] == NSOrderedDescending || [compareNumber compare:ONE_BILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@B", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_BILLION]]];
	} else if ([compareNumber compare:ONE_HUNDRED_MILLION] == NSOrderedDescending || [compareNumber compare:ONE_HUNDRED_MILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_MILLION]]];
	} else if ([compareNumber compare:TEN_MILLION] == NSOrderedDescending || [compareNumber compare:TEN_MILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_MILLION]]];
	} else if ([compareNumber compare:ONE_MILLION] == NSOrderedDescending || [compareNumber compare:ONE_MILLION] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_MILLION]]];
	} else if ([compareNumber compare:ONE_HUNDRED_THOUSAND] == NSOrderedDescending || [compareNumber compare:ONE_HUNDRED_THOUSAND] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@K", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_THOUSAND]]];
	} else if ([compareNumber compare:TEN_THOUSAND] == NSOrderedDescending || [compareNumber compare:TEN_THOUSAND] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@K", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_THOUSAND]]];
	} else if ([compareNumber compare:ONE_THOUSAND] == NSOrderedDescending || [compareNumber compare:ONE_THOUSAND] == NSOrderedSame) {
		return [NSString stringWithFormat:@"%@K", [formatter stringFromNumber:[number decimalNumberByDividingBy:ONE_THOUSAND]]];
	}else {
		return [number stringValue];
	}
}


+ (NSString *)prettyNSInteger:(NSInteger)number {
	if (number >= 10000000) {
		return [NSString stringWithFormat:@"%iM", (number/1000000)];
	} else if (number >= 10000) {
		return [NSString stringWithFormat:@"%iK", (number/1000)];
	} else {
		return [NSString stringWithFormat:@"%i", number];
	}
}


+ (NSString *)prettyCodeValue:(NSString *)originalString {
	return [[originalString stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
	
}


+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end

//
//  Util.m
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Util.h"
#import "LEMacros.h"

/*
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
*/

@implementation Util


+ (CGFloat)heightForText:(NSString *)text inFrame:(CGRect)frame withFont:(UIFont *)font {
	if (!text || (id)text == [NSNull null]) {
		text = @"";
	}
	// NOTE: FLT_MAX is a large float. Returned height will be less.
	CGSize cellSize = CGSizeMake(frame.size.width - 10, FLT_MAX);
	cellSize = [text sizeWithFont:font 
				   constrainedToSize:cellSize
					   lineBreakMode:NSLineBreakByWordWrapping];
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
	return [Util asString:obj];
}


+ (NSString *)asString:(id)obj {
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
		}else if ([obj isKindOfClass:[NSNumber class]]) {
			result = [NSDecimalNumber decimalNumberWithString:[obj stringValue]];
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
	NSString *result;
	bool isNegative = NO;
	if (isNotNull(number)) {
		NSString *numberAsString = [number stringValue];
		NSInteger numDigits = [numberAsString length];
		NSRange dotRange = [numberAsString rangeOfString:@"."];
		if (dotRange.location != NSNotFound) {
			numDigits = dotRange.location;
		}
		if ([numberAsString characterAtIndex:0] == '-') {
			numDigits--;
			isNegative = YES;
			numberAsString = [numberAsString substringFromIndex:1];
		}
		NSInteger numDigitsInRange = numDigits % 3;
		NSInteger maxNumberRange = numDigits / 3;
		if (numDigitsInRange == 0) {
			numDigitsInRange = 3;
			maxNumberRange--;
		}
		
		if ( ([number compare:[NSDecimalNumber zero]]==NSOrderedDescending) && ([number compare:[NSDecimalNumber one]]==NSOrderedAscending) ) {
			result = numberAsString;
		} else if (numDigits == 1) {
			result = [numberAsString substringToIndex:1];
		} else if (numDigits == 2) {
			result = [numberAsString substringToIndex:2];
		} else if (numDigits == 3) {
			result = [numberAsString substringToIndex:3];
		} else {
			NSString *base;
			switch (numDigitsInRange) {
				case 1:
					if (isNegative) {
						base = [NSString stringWithFormat:@"%@.%@", [numberAsString substringToIndex:1], [numberAsString substringWithRange:NSMakeRange(1, 1)]];
					} else {
						base = [NSString stringWithFormat:@"%@.%@", [numberAsString substringToIndex:1], [numberAsString substringWithRange:NSMakeRange(1, 2)]];
					}
					break;
				case 2:
					if (isNegative) {
						base = [numberAsString substringToIndex:2];
					} else {
						base = [NSString stringWithFormat:@"%@.%@", [numberAsString substringToIndex:2], [numberAsString substringWithRange:NSMakeRange(2, 1)] ];
					}
					break;
				case 3:
					base = [numberAsString substringToIndex:3];
					break;
				default:
					base = @"Unknown";
					break;
			}
			switch (maxNumberRange) {
				case 1:
					result = [NSString stringWithFormat:@"%@%@", base, @"K"];
					break;
				case 2:
					result = [NSString stringWithFormat:@"%@%@", base, @"M"];
					break;
				case 3:
					result = [NSString stringWithFormat:@"%@%@", base, @"B"];
					break;
				case 4:
					result = [NSString stringWithFormat:@"%@%@", base, @"T"];
					break;
				default:
					result = [NSString stringWithFormat:@"%@%@", base, @"?"];
					break;
			}
		}
	} else {
		result = @"0";
	}
	
	if (isNegative) {
		result = [NSString stringWithFormat:@"-%@", result];
	}
	return result;
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

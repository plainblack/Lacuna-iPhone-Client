//
//  Util.h
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {

}


+ (CGFloat)heightForText:(NSString *)text inFrame:(CGRect)frame withFont:(UIFont *)font;

+ (NSInteger)numPagesForCount:(NSInteger)count;

+ (NSString *)idFromDict:(NSDictionary *)dict named:(NSString *)name;
+ (NSString *)asString:(id)obj;
+ (NSDecimalNumber *)decimalFromInt:(NSInteger)inNumber;
+ (NSDate *)date:(NSString *)serverDateString;
+ (NSString *)formatDate:(NSDate *)serverDate;
+ (NSString *)prettyDate:(NSString *)serverDateString;

+ (NSDecimalNumber *)asNumber:(NSString *)string;
+ (NSString *)prettyDuration:(NSInteger)seconds;
+ (NSString *)prettyNSDecimalNumber:(NSDecimalNumber *)number;
+ (NSString *)prettyNSInteger:(NSInteger)number;
+ (NSString *)prettyCodeValue:(NSString *)originalString;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;



@end

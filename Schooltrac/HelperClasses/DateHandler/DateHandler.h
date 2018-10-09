//
//  DateHandler.h
//  Schooltrac
//
//  Created by Netstratum on 2/12/16.
//  Copyright © 2016 Rakesh palotra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandler : NSObject

+ (NSDate *)getUTCFormattedDateFromDateString:(NSString *)dateString;
+ (NSString *)getUTCFormattedDateStringFromDate:(NSDate *)date;
+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;
+ (NSDate *)getUTCFormattedDateOnly:(NSString *)dateString;
+ (NSString *)getLocaleFormattedDateStringFromDate:(NSDate *)date;
+ (NSString *)getLocaleDateStringFromDate:(NSDate *)date;
+ (NSDate *)getFormattedDateFromDateString:(NSString *)dateString;

@end

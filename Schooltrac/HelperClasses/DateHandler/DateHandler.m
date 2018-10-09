//
//  DateHandler.m
//  Schooltrac
//
//  Created by Netstratum on 2/12/16.
//  Copyright © 2016 Rakesh palotra. All rights reserved.
//

#import "DateHandler.h"

static NSDateFormatter *dateFormatter;

@implementation DateHandler

+ (NSDate *)getUTCFormattedDateFromDateString:(NSString *)dateString {
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    NSDate *utcDate = [dateFormatter dateFromString:dateString];
    
    return utcDate;
}

+ (NSString *)getUTCFormattedDateStringFromDate:(NSDate *)date {
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending && [date compare:lastDate] == NSOrderedAscending;
}

+ (NSDate *)getUTCFormattedDateOnly:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *utcDate = [formatter dateFromString:dateString];
    
    return utcDate;
}

+ (NSString *)getLocaleFormattedDateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getLocaleDateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd/MM/yy hh:mm a"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)getFormattedDateFromDateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDate *formattedDate = [formatter dateFromString:dateString];
    
    return formattedDate;
}
@end

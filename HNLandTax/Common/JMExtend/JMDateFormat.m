//
//  JMDateFormat.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMDateFormat.h"

@implementation JMDateFormat

+(double)jm_currentTimestamp{
    return [[NSDate date] timeIntervalSince1970];
}


+(NSInteger)jm_timesampWithDate:(NSString *)date format:(NSString *)format{
    return  [[self jm_dateWithTime:date format:format] timeIntervalSince1970];
}


+(NSDate *)jm_dateWithTime:(NSString *)date format:(NSString *)format{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"HTK"];
    [inputFormatter setDateFormat:format ? :@"yyyy-MM-dd"];
    return [inputFormatter dateFromString:date];
}


+(NSString *)jm_currentDateFormatString:(JMDateFormatType)type Style:(JMSeparatorCharStyle)style{
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    return [self jm_formateDate:timeStamp withFormate:[self timeFormatString:type AndStyle:style]];
}


+(NSString *)jm_formatWithDefault:(double)timestamp{
    return [self jm_formateDate:timestamp withFormate:@"yyyy-MM-dd"];
}

+(NSString *)jm_dateWithTimestamp:(double)timestamp FormatString:(JMDateFormatType)type Style:(JMSeparatorCharStyle)style{
    return [self jm_formateDate:timestamp withFormate:[self timeFormatString:type AndStyle:style]];
}

+(NSString *)jm_formateDate:(double)timestamp withFormate:(NSString *)formatString{
    if (formatString == nil||formatString.length == 0) {
        formatString = @"yyyy-MM-dd";
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"HTK"];
    [inputFormatter setDateFormat:formatString];
    NSDate *date=  [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *TimeStr = [inputFormatter stringFromDate:date];
    return TimeStr;
}

+(NSString *)timeFormatString:(JMDateFormatType)formatType AndStyle:(JMSeparatorCharStyle)SeparatorCharStyle{
    NSString *formatSting;
    
    switch (formatType) {
        case JMDateFormatTypeNormal:
            formatSting = @"yyyy-MM-dd";
            break;
        case JMDateFormatTypeTominutes:
            formatSting = @"yyyy-MM-dd HH:mm";
            break;
        case JMDateFormatTypeAll:
            formatSting = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            break;
    }
    
    if (SeparatorCharStyle == JMSeparatorCharStyleChinese) {
        switch (formatType) {
            case JMDateFormatTypeNormal:
                formatSting = @"yyyy年MM月dd日";
                break;
            case JMDateFormatTypeTominutes:
                formatSting = @"yyyy年MM月dd日 HH:mm";
                break;
            case JMDateFormatTypeAll:
                formatSting = @"yyyy年MM月dd日 HH:mm:ss";
                break;
            default:
                break;
        }
    }else{
        switch (SeparatorCharStyle) {
            case JMSeparatorCharStylePoint:
                formatSting =  [formatSting stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                break;
            case JMSeparatorCharStyleObliqueLine:
                formatSting =  [formatSting stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                break;
            default:
                break;
        }
        
    }
    return formatSting;
}


+(NSDateComponents *)getconstellationWithTimeStamp:(NSTimeInterval)timeStamp{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                       fromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
}
+(NSDateComponents *)jm_getCurrCalender{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    return [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitWeekday|NSCalendarUnitCalendar
                       fromDate:[NSDate date]];
}

@end

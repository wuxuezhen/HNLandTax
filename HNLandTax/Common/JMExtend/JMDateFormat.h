//
//  JMDateFormat.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JMDateFormatType) {
    JMDateFormatTypeNormal      =  0,
    JMDateFormatTypeTominutes,
    JMDateFormatTypeAll
};

typedef NS_ENUM(NSInteger, JMSeparatorCharStyle) {
    JMSeparatorCharStyleHoriLine    =  0,
    JMSeparatorCharStyleObliqueLine,
    JMSeparatorCharStylePoint,
    JMSeparatorCharStyleChinese
};

@interface JMDateFormat : NSObject

/**获取当前时间戳**/
+(double)jm_currentTimestamp;


/**
 根据时间字符串获取时间戳

 @param date 时间字符串
 @param format 时间样式
 @return 时间戳
 */
+(NSInteger)jm_timesampWithDate:(NSString *)date format:(NSString *)format;


/**
 根据时间字符串获取时间
 
 @param date 时间字符串
 @param format 时间样式
 @return 时间
 */
+(NSDate *)jm_dateWithTime:(NSString *)date format:(NSString *)format;


/**获取当前日历**/
+(NSDateComponents *)jm_getCurrCalender;

/**获取当前时间**/
+(NSString *)jm_currentDateFormatString:(JMDateFormatType)type
                                  Style:(JMSeparatorCharStyle)style;

/**默认格式**/
+(NSString *)jm_formatWithDefault:(double)timestamp;

/**根据日期类型和风格得到时间**/
+(NSString *)jm_dateWithTimestamp:(double)timestamp
                     FormatString:(JMDateFormatType)type
                            Style:(JMSeparatorCharStyle)style;

/**自定义格式**/
+(NSString *)jm_formateDate:(double)timestamp
                withFormate:(NSString *)formatString;

+(NSDateComponents *)getconstellationWithTimeStamp:(NSTimeInterval)timeStamp;

@end

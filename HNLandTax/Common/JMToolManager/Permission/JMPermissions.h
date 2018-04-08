//
//  JMPermissions.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/2.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppFieldType.h"
@interface JMPermissions : NSObject

/** 运动打卡提示 **/
+(BOOL)jm_sportSignTip;

/**
 运动打卡提示默认开启
 */
+(void)jm_signTipDefaultOpen;

/**
 运动打卡提示清理
 */
+(void)jm_clearSportSignTip;



/**
 判断今天是否第一次打开运动界面

 @return 布尔值
 */
+(BOOL)jm_firstOpenForToday;


/**
 记录今天已经打开
 */
+(void)jm_recordOpenedForToday;


/**
 清除是今天打开运动界面的记录
 */
+(void)jm_clearWithToday;


/**
 记录今天已经打开日历次数
 */
+(void)jm_recordOpenedCalendarNumberForToday;

/**
 日历界面是否展示邀请好友提示
 */
+(BOOL)jm_sportCalendarInviteFriendsTip;

/**
 清除是今天邀请好友提示的记录
 */
+(void)jm_clearInviteFriendsTipWithToday;

@end

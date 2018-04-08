//
//  JMPermissions.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/2.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "JMPermissions.h"
#import "JMDateFormat.h"
@implementation JMPermissions
+(BOOL)jm_sportSignTip{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:JMSportSignTipKey];
}

+(void)jm_signTipDefaultOpen{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:JMSportSignTipKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(void)jm_clearSportSignTip{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JMSportSignTipKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)jm_firstOpenForToday{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    return ![[NSUserDefaults standardUserDefaults] boolForKey:date];
}

+(void)jm_recordOpenedForToday{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:date];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)jm_clearWithToday{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:date];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



+(void)jm_recordOpenedCalendarNumberForToday{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    NSString *key = [NSString stringWithFormat:@"openedCalendarNumber%@",date];
    NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (number < 4) {
        number ++ ;
        [[NSUserDefaults standardUserDefaults] setInteger:number forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}
+(BOOL)jm_sportCalendarInviteFriendsTip{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    NSString *key = [NSString stringWithFormat:@"openedCalendarNumber%@",date];
    NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return number <= 3;
}

+(void)jm_clearInviteFriendsTipWithToday{
    NSString *date = [JMDateFormat jm_formatWithDefault:[JMDateFormat jm_currentTimestamp]];
    NSString *key = [NSString stringWithFormat:@"openedCalendarNumber%@",date];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end

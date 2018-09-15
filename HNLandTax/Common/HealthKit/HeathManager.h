//
//  HeathManager.h
//  HNLandTax
//
//  Created by caiyi on 2018/9/14.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
@interface HeathManager : NSObject
#pragma mark - Reading HealthKit Access permissions

/**
 设置要获取数据类型的权限，写入权限暂时为空 先设置权限 再读取写入数据
 
 @param completion 回调
 */
-(void)fit_setHealthKitPermissionsCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion;



#pragma mark - Reading HealthKit Data
/**
 获取步数
 
 @param completionHandler 回调
 */
- (void)fit_todayStepCountForHealthKitCompletion:(void (^)(double, NSError *))completionHandler;

/**
 获取骑行距离
 
 @param completionHandler 回调
 */
- (void)fit_todayDistanceCyclingForHealthKitCompletion:(void (^)(double, NSError *))completionHandler;

/**
 获取步行+跑步距离
 
 @param completionHandler 回调
 */
- (void)fit_todayDistanceWalkingRunningForHealthKitCompletion:(void (^)(double, NSError *))completionHandler;



/**
 获取出生日期
 
 @return 出生日期
 */
- (NSString *)fit_dateOfBirthForHeathKit;

/**
 获取体重
 
 @completionHandler 回调
 */
- (void)fit_weightForHeathKit:(void (^)(double, NSError *))completionHandler;


/**
 获取身高
 
 @completionHandler 回调
 */
- (void)fit_heightForHeathKit:(void (^)(double, NSError *))completionHandler;

@end

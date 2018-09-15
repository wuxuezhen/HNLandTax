//
//  HeathManager.m
//  HNLandTax
//
//  Created by caiyi on 2018/9/14.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HeathManager.h"
@import UIKit;
@interface HeathManager()

@property (nonatomic) HKHealthStore *healthStore;

@end
@implementation HeathManager


#pragma mark - Reading HealthKit Access permissions

/**
 设置要获取数据类型的权限，写入权限暂时为空 先设置权限 再读取写入数据

 @param completion 回调
 */
-(void)fit_setHealthKitPermissionsCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion{
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *readDataTypes = [self dataTypesToRead];
        [self.healthStore requestAuthorizationToShareTypes:nil
                                                 readTypes:readDataTypes
                                                completion:^(BOOL success, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completion ? completion(success,error) : nil;
                                                    });
                                                }];
    }else{
        NSError *error = [NSError errorWithDomain:@"Equipment not supported"
                                             code:0
                                         userInfo:nil];
        completion ? completion(YES,error) : nil;
    }
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    //    生日
    HKCharacteristicType *birthday   = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    //    性别
    HKCharacteristicType  *sexType   = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    //    身高
    HKObjectType *height             = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //    体重
    HKObjectType *bodyMass           = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //    去脂体重
    HKObjectType *leanBodyMass       = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    //    身高体重指数
    HKObjectType *bodyMassIndex      = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    //    体脂率
    HKObjectType *bodyFatPercentage  = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    //    步数
    HKObjectType *stepCount          = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //    步行+跑步距离
    HKObjectType *walkRun            = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    //    骑车距离
    HKObjectType *cycling            = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    //    已爬楼层
    HKObjectType *flightsClimbed     = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    //    静息能量
    HKObjectType *basalEnergyBurned  = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    //    活动能量
    HKObjectType *activeEnergyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];

  
    return [NSSet setWithObjects:birthday,sexType,height,bodyMass,leanBodyMass,bodyMassIndex,bodyFatPercentage,
            stepCount,walkRun,cycling,flightsClimbed,basalEnergyBurned,activeEnergyBurned,nil];
}


#pragma mark - Reading HealthKit Data
/**
 获取步数

 @param completionHandler 回调
 */
- (void)fit_todayStepCountForHealthKitCompletion:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    [self fetchTodayForType:stepType unit:[HKUnit countUnit] completion:completionHandler];
}

/**
 获取骑行距离
 
 @param completionHandler 回调
 */
- (void)fit_todayDistanceCyclingForHealthKitCompletion:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    [self fetchTodayForType:stepType unit:[HKUnit meterUnit] completion:completionHandler];
}

/**
 获取步行+跑步距离
 
 @param completionHandler 回调
 */
- (void)fit_todayDistanceWalkingRunningForHealthKitCompletion:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    [self fetchTodayForType:stepType unit:[HKUnit meterUnit] completion:completionHandler];
}


/**
 获取出生日期

 @return 出生日期
 */
- (NSString *)fit_dateOfBirthForHeathKit{
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    NSString *birth = nil;
    if (dateOfBirth) {
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                          fromDate:dateOfBirth
                                                                            toDate:[NSDate date]
                                                                           options:NSCalendarWrapComponents];
        NSUInteger usersAge = [ageComponents year];
        birth = [NSNumberFormatter localizedStringFromNumber:@(usersAge)
                                                 numberStyle:NSNumberFormatterNoStyle];
    }
    return birth;
}

/**
 获取体重
 
 @completionHandler 回调
 */
- (void)fit_weightForHeathKit:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self sampleQueryForType:stepType completion:^(HKQuantity *quantity, NSError *error) {
        if (quantity) {
            double kg  = [quantity doubleValueForUnit:[HKUnit gramUnit]] / 1000;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(kg , error): nil;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(0.0f , error): nil;
            });
        }
    }];
}


/**
 获取身高
 
 @completionHandler 回调
 */
- (void)fit_heightForHeathKit:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    [self sampleQueryForType:stepType completion:^(HKQuantity *quantity, NSError *error) {
        if (quantity) {
            double kg  = [quantity doubleValueForUnit:[HKUnit meterUnit]] / 1000;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(kg , error): nil;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(0.0f , error): nil;
            });
        }
    }];
}



#pragma mark - 通用方法
/**
 根据类型匹配数据 单个数据
 
 @param quantityType 类型
 @param completionHandler 回调
 */
- (void)sampleQueryForType:(HKQuantityType *)quantityType
                completion:(void (^)(HKQuantity * , NSError *))completionHandler{
    //查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标
    
    NSSortDescriptor *end  = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]
                                  initWithSampleType:quantityType
                                  predicate:nil
                                  limit:1
                                  sortDescriptors:@[end]
                                  resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                      if (error || results.count == 0) {
                                          completionHandler(nil,error);
                                      }else{
                                          HKQuantitySample *quantitySample = results.firstObject;
                                          HKQuantity *quantity = quantitySample.quantity;
                                          completionHandler(quantity,error);
                                      }
                                  }];
    [self.healthStore executeQuery:sampleQuery];
}


/**
 根据类型匹配数据

 @param quantityType 类型
 @param unit 单位
 @param completionHandler 回调
 */
- (void)fetchTodayForType:(HKQuantityType *)quantityType
                     unit:(HKUnit *)unit
               completion:(void (^)(double, NSError *))completionHandler {
    
    NSPredicate *predicate = [self predicateForSamplesToday];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType
                                                       quantitySamplePredicate:predicate
                                                                       options:HKStatisticsOptionCumulativeSum
                                                             completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                                                                 
                                                                 HKQuantity *sum = [result sumQuantity];
                                                                 if (completionHandler) {
                                                                     double value = [sum doubleValueForUnit:unit];
                                                                     completionHandler(value, error);
                                                                 }
                                                                 
                                                             }];
    [self.healthStore executeQuery:query];
}



#pragma mark - today date
- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}










#pragma mark - writing HealthKit Data

/**
 写入步数

 @param stepNum 步数
 */
- (void)fit_addstepWithStepNum:(double)stepNum {
    HKQuantitySample *stepQuantitySample = [self stepCorrelationWithStepNum:stepNum];
    [self.healthStore saveObject:stepQuantitySample
                  withCompletion:^(BOOL success, NSError *error) {
                      
                  }];
}


- (HKQuantitySample *)stepCorrelationWithStepNum:(double)stepNum {
    NSDate *endDate          = [NSDate date];
    NSDate *startDate        = [NSDate dateWithTimeInterval:-300 sinceDate:endDate];
    HKQuantity *stepQuantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:stepNum];
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    return[HKQuantitySample quantitySampleWithType:stepType
                                          quantity:stepQuantity
                                         startDate:startDate
                                           endDate:endDate
                                            device:[HKDevice localDevice]
                                          metadata:nil];

}

-(HKHealthStore *)healthStore{
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end

//
//  FITLocationManager.h
//  FitBody
//
//  Created by caiyi on 2018/8/22.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface FITLocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL isLocationSuccess;
@property (nonatomic, copy) NSString * _Nullable currentCity;


/**
 定位单例

 @return locationM
 */
+ (instancetype _Nonnull)locationManager;

/**
 定位是否打开
 
 @return 是否
 */
+ (BOOL)fit_openLocation;


/**
 开始持续定位
 */
- (void)fit_startUpdatingLocation;

/**
 开始单次定位
 */
- (void)fit_startSingleLocation;

/**
 停止定位
 */
- (void)fit_stopUpdatingLocation;


/**
 默认单次定位
 
 @param ReGeocode 是否返回逆地理信息
 @param locationSuccess 成功回调
 */
- (void)fit_startAMapLocationWithReGeocode:(BOOL)ReGeocode
                           locationSuccess:(void (^_Nullable)(CLLocation * _Nullable location, AMapLocationReGeocode * _Nullable reGeocode))locationSuccess;

@end

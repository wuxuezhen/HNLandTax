//
//  FITLocationManager.m
//  FitBody
//
//  Created by caiyi on 2018/8/22.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "FITLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface FITLocationManager()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *aMapLocationManager;
@property (nonatomic, copy) void (^locationSuccess) (CLLocation *location, AMapLocationReGeocode *reGeocode);
@property (nonatomic, assign) BOOL isUpdatingLocation;
@end

@implementation FITLocationManager

/**
 获取定位单例

 */
+ (instancetype)locationManager{
    static FITLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AMapServices sharedServices].apiKey = @"ff76a04a86db721770d1f22433d76265";
        [[AMapServices sharedServices] setEnableHTTPS:YES];
        manager = [[FITLocationManager alloc]init];
    });
    return manager;
}

/**
 定位是否打开
 
 @return 是否
 */
+ (BOOL)fit_openLocation{
    return [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}


/**
 开始持续定位。注：如果使用持续定位，需要手动调用停止定位方法。
 */
- (void)fit_startUpdatingLocation{
    self.isUpdatingLocation = YES;
    [self.aMapLocationManager startUpdatingLocation];
}

/**
 开始单次定位
 */
- (void)fit_startSingleLocation{
    self.isUpdatingLocation = NO;
    [self.aMapLocationManager startUpdatingLocation];
}

/**
 停止定位
 */
- (void)fit_stopUpdatingLocation{
    [self.aMapLocationManager stopUpdatingLocation];
}


/**
 开始定位

 @param ReGeocode 是否获取地址信息
 @param locationSuccess 定位成功回调
 */
- (void)fit_startAMapLocationWithReGeocode:(BOOL)ReGeocode locationSuccess:(void (^)(CLLocation *, AMapLocationReGeocode *))locationSuccess{
    self.locationSuccess = locationSuccess;
    self.aMapLocationManager.locatingWithReGeocode = ReGeocode;
    [self fit_startSingleLocation];
}



#pragma make - AMapLocationManagerDelegate
/**
 定位失败

 @param manager 定位对象
 @param error 异常信息
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    self.isLocationSuccess = NO;
    [manager stopUpdatingLocation];
}


/**
 定位成功

 @param manager 定位对象
 @param location 位置信息（经纬度等信息）
 @param reGeocode 地址信息（逆地理信息）
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.coordinate = location.coordinate;
    self.isLocationSuccess = YES;
    if(reGeocode){
        self.currentCity = reGeocode.city;
    }
    if(self.locationSuccess){
        self.locationSuccess(location, reGeocode);
    }
    if (!self.isUpdatingLocation) {
        [manager stopUpdatingLocation];
    }
}


/**
 懒加载定位对象

 @return 定位实例
 */
-(AMapLocationManager *)aMapLocationManager{
    if (!_aMapLocationManager){
        _aMapLocationManager = [[AMapLocationManager alloc] init];
        _aMapLocationManager.delegate = self;
        _aMapLocationManager.distanceFilter = 5;
        _aMapLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //连续定位是否返回逆地理信息
        _aMapLocationManager.locatingWithReGeocode = NO;
        
        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
        _aMapLocationManager.pausesLocationUpdatesAutomatically = NO;

        //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            _aMapLocationManager.allowsBackgroundLocationUpdates = YES;
        }
      
    }
    return _aMapLocationManager;
}
@end

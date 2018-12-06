//
//  JMLocationManager.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "JMLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface JMLocationManager()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *aMapLocationManager;
@property (nonatomic, copy)   wz_locationHandler locationHandler;
@property (nonatomic, assign) BOOL isReGeocode;
@property (nonatomic, assign) BOOL isUpdating;
@end

@implementation JMLocationManager

+ (instancetype)shareManager{
    static JMLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AMapServices sharedServices].apiKey = @"ff76a04a86db721770d1f22433d76265";
        [[AMapServices sharedServices] setEnableHTTPS:YES];
        manager = [[JMLocationManager alloc]init];
    });
    return manager;
}

/**
 定位权限是否f打开
 @return yes/no
 */
+ (BOOL)wz_openLocation{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}

/**
 开始定位 默认单次定位
 @param reGeocode 城市信息
 @param locationHandler 回调
 */
- (void)wz_startAMapLocationWithReGeocode:(BOOL)reGeocode locationHandler:(wz_locationHandler)locationHandler{
    self.locationHandler = locationHandler;
    self.isReGeocode     = reGeocode;
    self.isUpdating      = NO;
    self.aMapLocationManager.locatingWithReGeocode = reGeocode;
    [self wz_startUpdatingLocation];
}

/**
 开始定位 默认不反地理编码
 @param updating 是否持续定位
 @param locationHandler 回调
 */
- (void)wz_startAMapLocationWithUpdating:(BOOL)updating locationHandler:(wz_locationHandler)locationHandler{
    self.locationHandler = locationHandler;
    self.isUpdating      = updating;
    self.isReGeocode     = NO;
    self.aMapLocationManager.locatingWithReGeocode = NO;
    [self wz_startUpdatingLocation];
}


/**
 开始定位
 */
-(void)wz_startUpdatingLocation{
    [self.aMapLocationManager startUpdatingLocation];
}

/**
 停止定位
 */
-(void)wz_stopUpdatingLocation{
    [self.aMapLocationManager stopUpdatingLocation];
}


#pragma make - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self wz_stopUpdatingLocation];
    self.isLocationSuccess = NO;
    self.locationHandler(nil, nil, error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.coordinate = location.coordinate;
    self.isLocationSuccess = YES;
    
    if (self.isReGeocode) {
        if(reGeocode){
            self.currentCity = reGeocode.city ?:@"";
            self.locationHandler(location, reGeocode, nil);
            [self.aMapLocationManager stopUpdatingLocation];
        }
    }else{
        self.locationHandler(location, nil, nil);
        if (!self.isUpdating) {
            [self wz_startUpdatingLocation];
        }
    }
    
}

-(AMapLocationManager *)aMapLocationManager{
    if (!_aMapLocationManager){
        _aMapLocationManager = [[AMapLocationManager alloc] init];
        _aMapLocationManager.delegate = self;
        _aMapLocationManager.distanceFilter = 10;
        _aMapLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _aMapLocationManager.locatingWithReGeocode = YES;
        _aMapLocationManager.delegate = self;
    }
    return _aMapLocationManager;
}
@end

//
//  JMLocationManager.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void (^wz_locationHandler)(CLLocation *_Nullable , AMapLocationReGeocode * _Nullable , NSError * _Nullable );
@interface JMLocationManager : NSObject

@property (nonatomic)         CLLocationCoordinate2D  coordinate;
@property (nonatomic, strong) AMapLocationReGeocode  *reGeocode;
@property (nonatomic, copy)   NSString               *currentCity;
@property (nonatomic, assign) BOOL                   isLocationSuccess;

+ (instancetype)shareManager;

/**
 开始定位 默认单次定位
 @param reGeocode 城市信息
 @param locationHandler 回调
 */
- (void)wz_startAMapLocationWithReGeocode:(BOOL)reGeocode
                          locationHandler:(wz_locationHandler)locationHandler;

/**
 开始定位 默认不反地理编码
 @param updating 是否持续定位
 @param locationHandler 回调
 */
- (void)wz_startAMapLocationWithUpdating:(BOOL)updating
                          locationHandler:(wz_locationHandler)locationHandler;

/**
 开始定位
 */
-(void)wz_startUpdatingLocation;

/**
 停止定位
 */
-(void)wz_stopUpdatingLocation;

/**
 是否打开定位
 @return yes/no
 */
+ (BOOL)wz_openLocation;

@end

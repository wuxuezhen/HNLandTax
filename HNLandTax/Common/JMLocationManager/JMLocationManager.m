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
@property (nonatomic, copy) void(^locationSuccess)(CLLocationCoordinate2D coordinate,AMapLocationReGeocode *reGeocode);
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

- (void)startAMapLocationWithReGeocode:(BOOL)ReGeocode location:(void (^ _Nullable)(CLLocationCoordinate2D, AMapLocationReGeocode *))location{
    self.locationSuccess = location;
    self.aMapLocationManager.locatingWithReGeocode = ReGeocode;
    [self.aMapLocationManager startUpdatingLocation];
}

#pragma make - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.aMapLocationManager stopUpdatingLocation];
    self.allowLocation = NO;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.coordinate = location.coordinate;
    self.allowLocation = YES;
    if(reGeocode){
        self.currentCity = reGeocode.city?:@"";
        if(self.locationSuccess){
            self.locationSuccess(location.coordinate, reGeocode);
        }
        [self.aMapLocationManager stopUpdatingLocation];
    }
}

+ (BOOL)jm_openLocation{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
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

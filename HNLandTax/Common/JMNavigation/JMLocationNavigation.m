//
//  JMLocationNavigation.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/2/23.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "JMLocationNavigation.h"
#import "JMKeyManager.h"
NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=bd09ll";
NSString *gaodeParameterFormat = @"iosamap://path?backScheme=%@&sourceApplication=%@&sid=BGVIS1&slat=%@&slon=%@&did=BGVIS2&dlat=%@&dlon=%@&dev=0&t=0&sname=%@&dname=%@";
NSString *QQParameterFormat = @"qqmap://map/routeplan?type=drive&tocoord=%f,%f&coord_type=1&policy=0&from=我的位置&to=%@&refer=%@";

@implementation JMLocationNavigation


+ (NSArray *)canOpenMaps:(CLLocationCoordinate2D)userLocation Anddestination:(CLLocationCoordinate2D)destinationCoordinate dname:(NSString *)dname{
    NSMutableArray *maps = [NSMutableArray arrayWithCapacity:0];
    
    CLLocation *destination = [[[CLLocation alloc]initWithLatitude:destinationCoordinate.latitude
                                                         longitude:destinationCoordinate.longitude]
                               locationBaiduFromMars];
    
    CLLocation *startLocation = [[[CLLocation alloc]initWithLatitude:userLocation.latitude
                                                           longitude:userLocation.longitude]
                                 locationBaiduFromMars];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:JMSystemAppName];
    
    if ([self canOpenURLBaiduMap]) {
        JMMapModel *map = [[JMMapModel alloc]init];
        map.mapType = kMapTypeBaidu;
        map.name = @"百度地图";
        map.url = [[NSString stringWithFormat:baiduParameterFormat,
                    startLocation.coordinate.latitude,
                    startLocation.coordinate.longitude,
                    destination.coordinate.latitude,
                    destination.coordinate.longitude,
                    dname
                    ]
                   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [maps addObject:map];
        
    }
    if ([self canOpenURLGaodeMap]) {
        JMMapModel *map = [[JMMapModel alloc] init];
        map.name = @"高德地图";
        map.dname = dname;
        map.mapType = kMapTypeGaode;
        map.url = [[NSString stringWithFormat:
                    gaodeParameterFormat,
                    @"weidu://",
                    appName,
                    @(userLocation.latitude),
                    @(userLocation.longitude),
                    @(destinationCoordinate.latitude),
                    @(destinationCoordinate.longitude),
                    @"我的位置",
                    dname
                    ] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; ;
        
        [maps addObject:map];
    }
    
    if ([self canOpenURLQQMap]) {
        JMMapModel *map = [[JMMapModel alloc]init];
        map.name = @"腾讯地图";
        map.mapType = kMapTypeQQ;
        map.url = [[NSString stringWithFormat:
                    QQParameterFormat,
                    destinationCoordinate.latitude,
                    destinationCoordinate.longitude,
                    dname,
                    @"weidu://"]
                   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [maps addObject:map];
    }
    JMMapModel *map = [[JMMapModel alloc]init];
    map.dCoordinate = destinationCoordinate;
    map.name = @"苹果地图";
    map.dname = dname;
    [maps addObject:map];
    //起点
    return maps;
    
}


+(BOOL)canOpenURLBaiduMap{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]];
}
+(BOOL)canOpenURLGaodeMap{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]];
}
+(BOOL)canOpenURLQQMap{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://map/"]];
}

@end

//
//  JMLocationManager.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface JMLocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, assign) BOOL allowLocation;

+ (instancetype)shareManager;

- (void)startAMapLocationWithReGeocode:(BOOL)ReGeocode
                              location:(void (^_Nullable)(CLLocationCoordinate2D coordinate,AMapLocationReGeocode *reGeocode))location;

+ (BOOL)jm_openLocation;

@end

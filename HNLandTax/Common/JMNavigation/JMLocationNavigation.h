//
//  JMLocationNavigation.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/2/23.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JMMapModel.h"
#import "CLLocation+Location.h"
@interface JMLocationNavigation : NSObject
+ (NSArray *)canOpenMaps:(CLLocationCoordinate2D)userLocation Anddestination:(CLLocationCoordinate2D)destinationCoordinate dname:(NSString *)dname;
@end

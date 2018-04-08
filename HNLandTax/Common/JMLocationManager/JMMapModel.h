//
//  JMMapModel.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, MapType) {
    kMapTypeApple,
    kMapTypeGaode,
    kMapTypeBaidu,
    kMapTypeQQ,
    kMapTypeGoogle
};

@interface JMMapModel : NSObject
@property (nonatomic, copy) NSString *name;
/** 目的地 **/
@property (nonatomic, copy) NSString *dname;
/** 目的地 **/
@property (nonatomic, copy) NSString *sname;

@property (nonatomic, copy) NSString *url;
@property (nonatomic) MapType mapType;
@property (nonatomic) CLLocationCoordinate2D dCoordinate;

@end

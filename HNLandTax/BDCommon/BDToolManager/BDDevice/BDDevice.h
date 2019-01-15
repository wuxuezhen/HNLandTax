//
//  BDDevice.h
//  BusinessDataPlatform
//
//  Created by 吴振振 on 2019/1/9.
//  Copyright © 2019 donghui lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDDevice : NSObject

#pragma mark - app
+ (NSString *)bd_appVersion;

+ (NSString *)bd_appBuild;

+ (NSString *)bd_appName;


#pragma mark - 系统
+ (NSString *)bd_systemVersion;

+ (NSString *)bd_systemName;


#pragma mark - 设备
+ (NSString *)bd_deviceName;

+ (NSString *)bd_deviceIDFV;

+ (NSString *)bd_deviceIDFA;

+ (NSString *)deviceLocalized;

+ (NSString *)bd_deviceType;
@end

NS_ASSUME_NONNULL_END

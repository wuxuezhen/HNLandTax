//
//  BDDevice.m
//  BusinessDataPlatform
//
//  Created by 吴振振 on 2019/1/9.
//  Copyright © 2019 donghui lv. All rights reserved.
//

#import "BDDevice.h"
#import <sys/utsname.h>
#import "BDKeyManager.h"
#import <AdSupport/AdSupport.h>
@implementation BDDevice

#pragma mark - app
+ (NSString *)bd_appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:BDSystemVersion];
}

+ (NSString *)bd_appBuild{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:BDSystemBuild];
}

+ (NSString *)bd_appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:BDSystemAppName];
}

#pragma mark - 系统
+ (NSString *)bd_systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)bd_systemName{
    return [[UIDevice currentDevice] systemName];
}

#pragma mark - 设备
+ (NSString *)bd_deviceName{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)bd_deviceIDFV{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)bd_deviceIDFA{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)deviceLocalized{
    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString *)bd_deviceType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
}

     
@end

//
//  JMNetWorkMonitor.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMNetWorkMonitor.h"
#import <AFNetworking/AFNetworking.h>

static JMNetWorkMonitor *netWorkMonitor;
static AFNetworkReachabilityManager *manager;

@implementation JMNetWorkMonitor

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkMonitor = [[JMNetWorkMonitor alloc]init];
        manager = [AFNetworkReachabilityManager sharedManager];
    });
    [manager startMonitoring];
    return netWorkMonitor;
}

-(void)checkNetworkConnectionStatus:(void(^)(NSString *sting))success{
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        NSString *message = nil;
        [manager stopMonitoring];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                message = @"未知的网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                message = @"无网络连接";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                message = @"您当前使用的是3G|4G网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                message = @"您已连接到Wifi";
                break;
            default:
                message = @"未知的网络";
                break;
        }
        if (success) {
            success(message);
        }
    }];
    
}
@end

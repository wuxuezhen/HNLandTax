//
//  JMNetWorkMonitor.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMNetWorkMonitor : NSObject

+ (instancetype)sharedManager;

-(void)checkNetworkConnectionStatus:(void(^)(NSString *sting))success;

@end

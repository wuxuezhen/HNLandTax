//
//  JMCacheManager.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/5/25.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JMCacheManager : NSObject


/**
 清理web缓存
 */
+ (void)jm_clearWebache;


/**
 清理缓存
 */
+ (void)jm_clearache;


/**
 计算缓存大小

 @return 缓存大小
 */
+ (CGFloat)jm_cacheSize;
@end

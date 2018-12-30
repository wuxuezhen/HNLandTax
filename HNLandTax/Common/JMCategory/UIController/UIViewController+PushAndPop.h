//
//  UIViewController+PushAndPop.h
//  AZCategoryDemo
//
//  Created by Alfred Zhang on 2017/7/30.
//  Copyright © 2017年 Alfred Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PushAndPop)

/**
 控制相同类型的vc最多在同一个导航栈中存在几个，当vc被移除后，会回调[vc mgCleanup]方法
 
 @return 个数（0无限制）
 */
+ (NSUInteger)cyclePushLimitNumber;

@end

//
//  UIView+FITHud.h
//  FitBody
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FITHud)

/**
 展示加载框

 @param text 文字
 */
- (void)fit_showProgressHud:(NSString *)text;


/**
 展示加载框
 */
- (void)fit_showProgressHud;


/**
 移除加载框
 */
- (void)fit_dismissHud;


/**
 判断是否有加载框

 @return
 */
- (BOOL)fit_hudExist;

@end

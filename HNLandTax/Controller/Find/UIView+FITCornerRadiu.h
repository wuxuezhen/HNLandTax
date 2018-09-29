//
//  UIView+FITCornerRadiu.h
//  FitBody
//
//  Created by caiyi on 2018/9/29.
//  Copyright © 2018 caiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FITCornerRadiu)

#pragma mark - 性能差的方法 FPS：40多
/**
 设置圆角 切掉圆角部分 默认
 @param cornerRadius 圆角大小
 */
-(void)fit_setCornerRadius:(CGFloat)cornerRadius;


/**
 设置圆角 切掉圆角部分 圆角可以自定义位置
 @param corners     圆角位置 左上|右上|左下|右下
 @param cornerRadii 圆角尺寸
 */
-(void)fit_byRoundingCorners:(UIRectCorner)corners
                 cornerRadii:(CGSize)cornerRadii;


#pragma mark - 性能高的方法 FPS：59左右
/**
 设置圆角 保留圆角部分可设置颜色 圆角可以自定义位置
 @param cornerRadius    圆角大小
 @param backgroundColor 背景颜色-圆角部分颜色
 @param fillColor       填充颜色
 */
-(void)fit_addCornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor
                 fillColor:(UIColor *)fillColor;


/**
 设置圆角 保留圆角部分可设置颜色 圆角可以自定义位置
 @param corners         圆角位置 左上|右上|左下|右下
 @param cornerRadii     圆角尺寸
 @param backgroundColor 背景颜色-圆角部分颜色
 @param fillColor       填充颜色
 */
-(void)fit_addRoundingCorners:(UIRectCorner)corners
                  cornerRadii:(CGSize)cornerRadii
              backgroundColor:(UIColor *)backgroundColor
                    fillColor:(UIColor *)fillColor;

@end

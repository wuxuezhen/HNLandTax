//
//  UIView+FITCornerRadiu.m
//  FitBody
//
//  Created by caiyi on 2018/9/29.
//  Copyright © 2018 caiyi. All rights reserved.
//

#import "UIView+FITCornerRadiu.h"

@implementation UIView (FITCornerRadiu)

/**
 设置圆角 切掉圆角部分 默认
 @param cornerRadius 圆角大小
 */
-(void)fit_setCornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:cornerRadius];
    self.layer.mask          = [self fit_layerWithBezierPath:path];
    self.layer.masksToBounds = YES;
}


/**
 设置圆角 切掉圆角部分 圆角可以自定义位置
 @param corners     圆角位置 左上|右上|左下|右下
 @param cornerRadii 圆角尺寸
 */
-(void)fit_byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:cornerRadii];
    self.layer.mask          = [self fit_layerWithBezierPath:path];
    self.layer.masksToBounds = YES;
}


/**
 设置圆角 保留圆角部分可设置颜色 圆角可以自定义位置
 @param cornerRadius    圆角大小
 @param backgroundColor 背景颜色-圆角部分颜色
 @param fillColor       填充颜色
 */
-(void)fit_addCornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor
                 fillColor:(UIColor *)fillColor{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:cornerRadius];
    CAShapeLayer *masklayer    = [self fit_layerWithBezierPath:path];
    self.layer.backgroundColor = backgroundColor.CGColor;
    masklayer.fillColor        = fillColor.CGColor;
    [self.layer insertSublayer:masklayer atIndex:0];
}


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
                    fillColor:(UIColor *)fillColor{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:cornerRadii];
    CAShapeLayer *masklayer    = [self fit_layerWithBezierPath:path];
    self.layer.backgroundColor = backgroundColor.CGColor;
    masklayer.fillColor        = fillColor.CGColor;
    [self.layer insertSublayer:masklayer atIndex:0];
}

/**
 根据贝塞尔曲线创建图层
 @param path 贝塞尔曲线
 @return 图层
 */
-(CAShapeLayer *)fit_layerWithBezierPath:(UIBezierPath *)path{
    CAShapeLayer *masklayer = [CAShapeLayer layer];
    masklayer.frame = self.bounds;
    masklayer.lineJoin = kCALineJoinRound;
    masklayer.lineCap = kCALineCapRound;
    masklayer.path = path.CGPath;
    return masklayer;
}

@end


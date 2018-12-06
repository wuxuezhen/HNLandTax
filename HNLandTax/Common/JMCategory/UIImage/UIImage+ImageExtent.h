//
//  UIImage+ImageExtent.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageExtent)

/**
 改变画Image size
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)jm_changeColor:(UIColor *)color;
//- (UIImage *)jm_waterMark;

/** 通过颜色截取图片 */
+ (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color;

+ (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color size:(CGSize)size;

+ (UIImage * _Nonnull)navShadowImage;

/**
 *@brief 截取整个视图为图片
 * @param currView 需要截取的视图
 */
+ (UIImage * _Nonnull)imageWithView:(UIView * _Nonnull)currView;

/**
 *@brief 截取视图为图片
 * @param currView 需要截取的视图
 * @param fram 截取的范围
 */
+ (UIImage * _Nonnull)imageWithView:(UIView * _Nonnull)currView fram:(CGRect)fram;

- (UIImage *_Nullable)fixOrientation;

- (UIImage *_Nullable)normalizedImage;

@end

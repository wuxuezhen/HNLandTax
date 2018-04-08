//
//  UIColor+JMColor.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/20.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JM_RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define JM_RGB_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
#define JM_RGB_HEXHEX(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:a]
@interface UIColor (JMColor)

/**
 背景灰
 */
+(UIColor *)jm_backgroudgaryColor;

/**
 背景浅灰
 */
+(UIColor *)jm_backgroudColor;

/**
 主题
 */
+(UIColor *)jm_themeColor;

+(UIColor *)jm_themeViewColor;
/**
 分割线身
 */
+(UIColor *)jm_lineGrayColor;

/**
 分割线浅
 */
+(UIColor *)jm_lineLigthgrayColor;

/**
 主要字体黑
 */
+(UIColor *)jm_textBlackColor;

/**
 字体深灰
 */
+(UIColor *)jm_textGrayColor;

/**
 字体浅灰
 */
+(UIColor *)jm_textLightgrayColor;

/**
 字体
 */
+(UIColor *)jm_textLightblackColor;

/**
 绿色
 */
+(UIColor *)jm_greenColor;

/*
 333333
 */
+(UIColor *)jm_333333;

/*
 F1F1F1
 */
+(UIColor *)jm_f1f1f1;
@end

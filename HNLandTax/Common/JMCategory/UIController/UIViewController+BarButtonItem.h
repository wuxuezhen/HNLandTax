//
//  UIViewController+BarButtonItem.h
//  FitBody
//
//  Created by caiyi on 2018/8/27.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarButtonItem)

#pragma mark - 设置父类导航
-(void)fit_setSuperNavnavigation;

/**
 通过图片创建导航栏右边按钮，需重写ld_rightBarButtonItemAction:
 @param imageName 图片名称
 */
- (void)fit_createLeftBarButtonItemWithImage:(NSString *)imageName;
/**
 通过文字创建导航栏右边按钮,需重写ld_rightBarButtonItemAction:
 @param title 按钮名称
 */
- (void)fit_createLeftBarButtonItemWithTitle:(NSString *)title;
/**
 导航右边按钮的点击行为
 */
- (void)fit_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem;




/**
 通过图片创建导航栏右边按钮，需重写ld_rightBarButtonItemAction:
 @param imageName 图片名称
 */
- (void)fit_createRightBarButtonItemWithImage:(NSString *)imageName;

/**
 通过文字创建导航栏右边按钮,需重写ld_rightBarButtonItemAction:
 @param title 按钮名称
 */
- (void)fit_createRightBarButtonItemWithTitle:(NSString *)title;

/**
 导航右边按钮的点击行为
 */
- (void)fit_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem;


@end

//
//  UIViewController+Alert.h
//  FitBody
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)


/*** 中间弹窗 包含确定、取消两个事件 **/
- (void)fit_showAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                 confirmAction:(void (^)(void))confirmAciton
                  cancelAction:(void (^)(void))cancelAciton;


/**
 中间弹窗 包含两个事件
 
 @param title 标题
 @param message 内容
 @param destructiveTitle 确定标题
 @param cancelTitle 取消标题
 @param confirmAciton 确定事件
 @param cancelAciton 取消事件
 */
- (void)fit_showAlertWithTitle:(NSString *)title
                       message:(NSString *)message
        destructiveActionTitle:(NSString *)destructiveTitle
             cancelActionTitle:(NSString *)cancelTitle
                 confirmAction:(void (^)(void))confirmAciton
                  cancelAction:(void (^)(void))cancelAciton;


/*** 中间弹窗仅确定事件 **/
- (void)fit_showAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                 confirmAction:(void (^)(void))confirmAciton;

- (void)fit_showAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                   actionTitle:(NSString *)actionTitle
                 confirmAction:(void (^)(void))confirmAciton;

@end

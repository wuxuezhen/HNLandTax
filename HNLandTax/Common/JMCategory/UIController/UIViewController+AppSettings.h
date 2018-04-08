//
//  UIViewController+AppSettings.h
//  TuoDian
//
//  Created by Mac Pro on 2017/10/13.
//  Copyright © 2017年 wxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AppSettings)


/**
 打卡设置界面
 */
- (void)jm_openAppSettings;

/**
 拨打电话

 @param phone 电话号码
 */
-(void)jm_callPhone:(NSString *)phone;
@end

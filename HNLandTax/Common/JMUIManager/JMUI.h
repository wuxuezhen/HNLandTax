//
//  JMUI.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMUI : NSObject

//利用工厂模式，将基本控件用静态方法创建，是能够更方便的修改类似的属性

//创建view
+(UIView *)createViewWithFream:(CGRect)fream;

//创建Label
+(UILabel *)createLabelWithFream:(CGRect)fream
                            text:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;
// 创建 Button
+(UIButton *)createButtonWithFream:(CGRect)fream
                             title:(NSString *)title
                        titleColor:(UIColor *)titleColor
                         imageName:(NSString *)imageName
               backgroundImageName:(NSString *)backgroundImageName
                            target:(id)target
                          selecter:(SEL)selecter;

+(UIButton *)createButtonWithimageName:(NSString *)imageName
                   backgroundImageName:(NSString *)backgroundImageName
                                target:(id)target
                              selecter:(SEL)selecter;

// 创建 ImageView
+(UIImageView *)createImageViewWithFream:(CGRect)fream
                               imageName:(NSString *)imageName;

// 创建 TextField
+(UITextField *)createTextFieldWithFream:(CGRect)fream
                                    text:(NSString *)text
                             placeHolder:(NSString *)placeHolder;

//创建加减按钮
+(UIStepper *)createStepper:(CGRect)fream
                      Value:(NSInteger)value
                        Max:(NSInteger)max
                        Min:(NSInteger)min
                     Target:(id)target
                   selecter:(SEL)selecter;

+(UITableView *)createTableViewWith:(CGRect)fream
                             target:(id)action
                              style:(UITableViewStyle)style;

//没有内容背景图
+(UIView *)backgroundWithNoContent;

@end

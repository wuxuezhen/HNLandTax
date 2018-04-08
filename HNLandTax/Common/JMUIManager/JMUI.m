//
//  JMUI.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMUI.h"

@implementation JMUI

+(UIView *)createViewWithFream:(CGRect)fream{
    UIView *view = [[UIView alloc]initWithFrame:fream];
    return view;
}

+(UILabel *)createLabelWithFream:(CGRect)fream text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:fream];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+(UIButton *)createButtonWithFream:(CGRect)fream title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selecter:(SEL)selecter{
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =fream;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (backgroundImageName) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    
    return button;

}

+(UIButton *)createButtonWithimageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selecter:(SEL)selecter{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (backgroundImageName) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UIImageView *)createImageViewWithFream:(CGRect)fream imageName:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:fream];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    return imageView;
}

+(UITextField *)createTextFieldWithFream:(CGRect)fream text:(NSString *)text placeHolder:(NSString *)placeHolder{
    UITextField *textFirld = [[UITextField alloc]initWithFrame:fream];
    textFirld.text = text;
    textFirld.placeholder = placeHolder;
    textFirld.borderStyle = UITextBorderStyleRoundedRect;
    return textFirld;
}

+(UIStepper *)createStepper:(CGRect)fream Value:(NSInteger)value Max:(NSInteger)max Min:(NSInteger)min Target:(id)target selecter:(SEL)selecter{
    UIStepper *stepper = [[UIStepper alloc]init];
    stepper.frame = fream;
    stepper.value = value;
    stepper.maximumValue = max;
    stepper.minimumValue = min;
    stepper.stepValue = 1;
    stepper.continuous = YES;
    stepper.wraps = NO;
    //stepper.tintColor = [UIColor lightGrayColor];//设置按钮的颜色;
    [stepper setBackgroundColor:[UIColor clearColor]];
    [stepper addTarget:target action:selecter forControlEvents:UIControlEventValueChanged];
    
    return stepper;
}

+(UITableView *)createTableViewWith:(CGRect)fream target:(id)action style:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:fream style:style];
    tableView.delegate = action;
    tableView.dataSource = action;
    if(style == UITableViewStylePlain){
        tableView.separatorInset = UIEdgeInsetsZero;
    }
    tableView.sectionHeaderHeight = CGFLOAT_MIN;
    tableView.sectionFooterHeight = CGFLOAT_MIN;
    tableView.tableFooterView = [[UIView alloc]init];
    return tableView;
}

+(UIView *)backgroundWithNoContent{
    UIView *view = [[UIView alloc]init];
    return view;
}
@end

//
//  JMCityPicker.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/24.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCityPicker : UIView
@property (nonatomic, copy) void (^pickerValueBlock)(NSString * value);
@property (nonatomic, copy) NSString *city;
-(instancetype)initLoadCityList;
- (void)show;
@end

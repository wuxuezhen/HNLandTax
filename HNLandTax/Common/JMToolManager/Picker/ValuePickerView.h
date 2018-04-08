//
//  ValuePickerView.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuePickerView : UIView

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, copy) void (^pickerValueBlock)(NSString * value);
-(void)show;
@end

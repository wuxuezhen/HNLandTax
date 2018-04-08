//
//  DatePickerView.h
//  Copyright © 2016年 zhangfaxing. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *dateFormat;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSDate *maxDate;
@property (nonatomic) NSDate *minDate;

@property (nonatomic, copy) void (^confirmBlock)(NSArray *dates);
@property (nonatomic ,copy) void (^cancelBlock)(void);

-(instancetype)initWithPickerMode:(UIDatePickerMode)mode;
-(void)show;
@end

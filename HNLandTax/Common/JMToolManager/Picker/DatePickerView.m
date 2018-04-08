//
//  DatePickerView.m
//  Copyright © 2016年 zhangfaxing. All rights reserved.
//

#import "DatePickerView.h"
#import "JMWeiDu.h"

#define PICK_HEIGHT  SCREEN_H/3

@interface DatePickerView()
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *makesureBtn;
@end

@implementation DatePickerView

-(instancetype)init{
    return [self initWithPickerMode:UIDatePickerModeDate];
}
-(instancetype)initWithPickerMode:(UIDatePickerMode)mode{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        
        self.backgroundColor = JM_RGB(0, 0, 0, 0.2);
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        
        if (mode) {
            self.datePicker.datePickerMode = mode;
        } else {
            self.datePicker.datePickerMode = UIDatePickerModeDate;
        }
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(PICK_HEIGHT);
        }];
        
        [self addSubview:self.toolBar];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.datePicker.mas_top);
            make.height.mas_equalTo(40);
        }];
        [self.toolBar addSubview:self.cancelBtn];
        [self.toolBar addSubview:self.makesureBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.toolBar);
            make.width.equalTo(@70);
        }];
        [self.makesureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.toolBar);
            make.width.equalTo(@70);
        }];
    }
    return self;
}


-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    UIButton *bu = [self viewWithTag:1];
    _cancelTitle = cancelTitle;
    [bu setTitle:cancelTitle forState:UIControlStateNormal];
}
-(void)setDate:(NSDate *)date{
    _date = date;
    _datePicker.date = date;
}
-(void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    _datePicker.maximumDate = maxDate;
}
-(void)setMinDate:(NSDate *)minDate{
    _maxDate = minDate;
    _datePicker.minimumDate = minDate;
}

/**弹出视图*/
- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = selfFrame;
    }];
}

-(void)remove{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = SCREEN_H;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = selfFrame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - action
//选择确定或者取消
-(void)makesureAction:(UIButton *)sender{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    if (self.dateFormat) {
        [dateformatter setDateFormat:self.dateFormat];
    } else {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *choseDateString = [dateformatter stringFromDate:_datePicker.date];
    NSString *timeInterval = @([_datePicker.date timeIntervalSince1970]).stringValue;
    NSArray *dates =@[choseDateString?:@"",timeInterval?:@""];
    self.confirmBlock ?  self.confirmBlock(dates) : nil;
    [self remove];
}

- (void)cancelAction:(UIButton *)sender {
    [self remove];
}



#pragma mark - 懒加载
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}


-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [JMUI createButtonWithFream:CGRectZero
                                           title:@"取消"
                                      titleColor:[UIColor darkGrayColor]
                                       imageName:nil
                             backgroundImageName:nil
                                          target:self
                                        selecter:@selector(cancelAction:)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancelBtn;
}
-(UIButton *)makesureBtn{
    if (!_makesureBtn) {
        _makesureBtn = [JMUI createButtonWithFream:CGRectMake(0, 0, 70, 50)
                                             title:@"确定"
                                        titleColor:[UIColor darkGrayColor]
                                         imageName:nil
                               backgroundImageName:nil
                                            target:self
                                          selecter:@selector(makesureAction:)];
    }
    _makesureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    return _makesureBtn;
}


-(UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc]init];
        _toolBar.backgroundColor = [UIColor jm_backgroudColor];
    }
    return _toolBar;
}
@end

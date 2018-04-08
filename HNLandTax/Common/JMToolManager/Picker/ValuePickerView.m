//
//  ValuePickerView.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "ValuePickerView.h"
#import "JMWeiDu.h"

#define PICK_HEIGHT  SCREEN_H/3

@interface ValuePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *makesureBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *valueStr;

@end

@implementation ValuePickerView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)]) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];
        [self addSubview:self.pickerView];
        self.backgroundColor = JM_RGB(0, 0, 0, 0.2);
        
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(PICK_HEIGHT);
        }];
        [self addSubview:self.toolBar];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.pickerView.mas_top);
            make.height.mas_equalTo(40);
        }];
        [self.toolBar addSubview:self.cancelBtn];
        [self.toolBar addSubview:self.makesureBtn];
        [self.toolBar addSubview:self.titleLabel];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.toolBar);
            make.width.equalTo(@70);
        }];
        [self.makesureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.toolBar);
            make.width.equalTo(@70);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(self.toolBar);
            make.width.equalTo(@(SCREEN_W - 150));
        }];
        
    }
    return self;
}

#pragma mark - ActionA
-(void)makesureAction:(UIButton *)btn{
    if (self.pickerValueBlock) {
        self.pickerValueBlock(self.valueStr);
    }
    [self remove];
}
-(void)cancelAction:(UIButton *)btn{
    [self remove];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.valueStr = self.dataSource[row];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return self.dataSource[row];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.valueStr = self.dataSource.firstObject;
}
- (void)setDefaultValue:(NSString *)defaultValue{
    if (defaultValue && defaultValue.length > 0) {
        _defaultValue = defaultValue;
        NSInteger row =  [self.dataSource indexOfObject:defaultValue];
        [self.pickerView selectRow:row inComponent:0 animated:NO];
        self.valueStr = defaultValue;
    }
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

#pragma mark - 懒加载

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

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
-(UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc]init];
        _toolBar.backgroundColor = [UIColor jm_backgroudColor];
    }
    return _toolBar;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [JMUI createLabelWithFream:CGRectZero
                                            text:@"选择"
                                       textColor:[UIColor blackColor]
                                            font:[UIFont boldSystemFontOfSize:13]];;
    }
    return _titleLabel;
}


@end

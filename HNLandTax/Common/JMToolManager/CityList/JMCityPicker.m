//
//  JMCityPicker.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/24.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMCityPicker.h"
#import "JMWeiDu.h"
#import "JMAPI.h"
#import "APPConstants.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define PICK_HEIGHT  SCREEN_H/3

@interface JMCityPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *makesureBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSArray *proArray;
@property (nonatomic, copy) NSArray *cityArray;
@property (nonatomic, copy) NSArray *areaArray;
@property (nonatomic, copy) NSString *proValue;
@property (nonatomic, copy) NSString *cityValue;
@end

@implementation JMCityPicker

- (instancetype)initLoadCityList{
    if (self = [super init]) {
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
            make.width.equalTo(@70);
        }];
        [self loadCityList];
       
    }
    return self;
}

-(void)defaultSelect{
    if (self.proArray.count > 0 && self.cityArray.count > 0 && self.city) {
        
        NSArray *arr = [self.city componentsSeparatedByString:@"-"];
        self.proValue = arr.firstObject;
        self.cityValue = arr.lastObject;
        NSInteger g = 0;
        NSInteger r = 0;
        for (int i = 0; i < self.proArray.count; i ++ ) {
            NSDictionary *dict = self.proArray[i];
            if ([arr.firstObject isEqualToString:dict[@"name"]]) {
                g = i;
                self.cityArray = dict[@"cityList"];
                for (int j = 0; j < self.cityArray.count; j ++ ) {
                    NSDictionary *dictc = self.cityArray[j];
                    if ([self.cityValue isEqualToString:dictc[@"cityName"]]) {
                        r = j;
                        break;
                    }
                }
                break;
            }
        }
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:g inComponent:0 animated:NO];
        [self.pickerView selectRow:r inComponent:1 animated:NO];
    }else{
        [self.pickerView reloadAllComponents];
    }
    
}


#pragma mark - ActionA
-(void)makesureAction:(UIButton *)btn{
    if (self.pickerValueBlock) {
        self.pickerValueBlock([NSString stringWithFormat:@"%@-%@",self.proValue,self.cityValue]);
    }
//    [self remove];
    [self removeFromSuperview];
}
-(void)cancelAction:(UIButton *)btn{
//    [self remove];
    [self removeFromSuperview];
}

/**弹出视图*/
- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}


-(void)loadCityList{
    [self showHud];
    NSString *url = [@"http:..." stringByAppendingString:@"city/list"];
    [JMAPI GET:url params:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass: NSArray.class]) {
            NSArray *lists = (NSArray *)responseObject;
            self.proArray = lists;
            NSDictionary *prodict = lists.firstObject;
            self.cityArray = prodict[@"cityList"];
            NSDictionary *citydict = self.cityArray.firstObject;
            self.proValue = prodict[@"name"];
            self.cityValue = citydict[@"cityName"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissHud];
                [self defaultSelect];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        self.proArray = @[];
        self.cityArray = @[];
    }];
    
}
#pragma mark - UI

- (void)showHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.pickerView animated:YES];
    hud.bezelView.backgroundColor = [UIColor clearColor];
}

- (void)dismissHud {
    [MBProgressHUD hideHUDForView:self.pickerView animated:YES];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.proArray.count;
    }else{
        return self.cityArray.count;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_W/2;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (self.proArray.count > row) {
            NSDictionary *prodict = self.proArray[row];
            self.proValue = prodict[@"name"]?:@"";
            self.cityArray = prodict[@"cityList"];
            NSDictionary *citydict = self.cityArray.firstObject;
            self.cityValue = citydict[@"cityName"]?:@"";
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    }else{
        if (self.cityArray.count > row) {
            NSDictionary *citydict = self.cityArray[row];
            self.cityValue = citydict[@"cityName"]?:@"";
        }
    }
    
}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        NSDictionary *prodict = self.proArray[row];
//        return prodict[@"name"]?:@"";
//    }else{
//        NSDictionary *citydict = self.cityArray[row];
//        return citydict[@"cityName"]?:@"";
//    }
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor lightGrayColor];
        }
    }
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        NSDictionary *prodict = self.proArray[row];
        label.text = prodict[@"name"]?:@"";
    }else{
        NSDictionary *citydict = self.cityArray[row];
        label.text = citydict[@"cityName"]?:@"";
    }
    return label;

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
                                            text:@"选择城市"
                                       textColor:[UIColor blackColor]
                                            font:[UIFont boldSystemFontOfSize:13]];;
    }
    return _titleLabel;
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
@end

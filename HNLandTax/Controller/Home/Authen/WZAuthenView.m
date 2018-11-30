//
//  WZAuthenView.m
//  HNLandTax
//
//  Created by wzz on 2018/11/30.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "WZAuthenView.h"
#import <Masonry/Masonry.h>
@interface WZAuthenView ()
@property (nonatomic, strong) UIButton *authBtn;
@end
@implementation WZAuthenView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.authBtn];
        [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(self.authBtn.currentImage.size);
        }];
    }
    return self;
}

-(void)touchAction{
    self.touchAuthBlock ? self.touchAuthBlock():nil;
}

-(UIButton *)authBtn{
    if (!_authBtn) {
        _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authBtn setImage:[UIImage imageNamed:@"touchID1"] forState:UIControlStateNormal];
        [_authBtn setImage:[UIImage imageNamed:@"touchID1"] forState:UIControlStateSelected];
        [_authBtn addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authBtn;
}

@end

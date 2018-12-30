//
//  HomeViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HomeViewController.h"
#import "DownloadViewController.h"
#import "DeletedViewController.h"
#import "WZLocalAuthentication.h"
#import "WZAuthenView.h"
#import "AddDataViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) WZLocalAuthentication *authentication;
@property (nonatomic, strong) WZAuthenView *authenView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *itemView;
@property (nonatomic, strong) UIView       *lineView;
@property (nonatomic, strong) NSMutableArray *itmes;
@property (nonatomic, copy)   NSArray        *classes;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wz_initParams];
    [self wz_initUI];
}

-(void)wz_initParams{
    self.itmes   = [NSMutableArray arrayWithCapacity:0];
    self.classes = @[[DownloadViewController class],
                     [DeletedViewController class]];
}

-(void)wz_initUI{
    [self fit_createRightBarButtonItemWithTitle:@"添加"];
    [self wz_createUI];
    [self wz_authentication];
}

-(void)wz_createUI{
    
    self.navigationItem.titleView = self.itemView;
    NSArray *titles = @[@"视频",@"历史"];
    CGFloat tWidth  = SCREEN_W / 3;
    for (int i = 0; i < titles.count;i++) {
        UIButton *headerbrn = [JMUI createButtonWithFream:CGRectMake(i*tWidth, 0, tWidth, 38)
                                                    title:titles[i]
                                               titleColor:[UIColor jm_textBlackColor]
                                                imageName:nil
                                      backgroundImageName:nil
                                                   target:self
                                                 selecter:@selector(titleBtnAction:)];
        
        headerbrn.titleLabel.font = [UIFont systemFontOfSize:16];
        headerbrn.tag = 10 +i;
        [self.itmes addObject:headerbrn];
        [ self.itemView addSubview:headerbrn];
    }
    self.lineView = [[UIView alloc]initWithFrame:[self lineViewFrameWithTag:0]];
    self.lineView.backgroundColor = [UIColor jm_textBlackColor];
    [self.itemView addSubview:self.lineView];
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    for (int i = 0; i<self.classes.count; i++) {
        UIViewController *vc = [[self.classes[i] alloc]init];
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.scrollView).offset(i * SCREEN_W);
            make.width.equalTo(self.scrollView);
            make.top.equalTo(self.mas_topLayoutGuide);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }];
    }

}

-(void)fit_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    AddDataViewController *add = [[AddDataViewController alloc]init];
    __weak typeof(self) this = self;
    add.addVideoSuccess = ^{
        for (UIViewController *vc in this.childViewControllers) {
            if ([vc isKindOfClass:DownloadViewController.class] ||
                [vc isKindOfClass:DeletedViewController.class]) {
                  ((void (*)(id, SEL))objc_msgSend)(vc, NSSelectorFromString(@"resetData"));
            }
        }
    };
    [self.navigationController pushViewController:add animated:YES];
    
}

-(void)titleBtnAction:(UIButton *)btn{
    NSInteger tag = btn.tag - 10;
    [self.scrollView setContentOffset:CGPointMake(tag * CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = [self lineViewFrameWithTag:tag];
    }];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int tag = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame) + 0.1;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = [self lineViewFrameWithTag:tag];
    }];
}

-(CGRect)lineViewFrameWithTag:(NSInteger)tag{
    UIButton *button = [self.itmes objectAtIndex:tag];
    CGPoint center = button.center;
    center.y = center.y + button.frame.size.height/2;
    center.x = center.x - 16;
    return CGRectMake(center.x, center.y, 32, 3);
}


#pragma mark - 指纹识别
-(void)wz_authentication{
    self.scrollView.hidden = YES;
    if ([self.authentication wz_canEvaluatePolicy]) {
        __weak typeof(self) this  = self;
        [self.authentication wz_evaluatePolicy:^(BOOL success, NSString * _Nullable message) {
            [this refreshUIWithMessage:message success:success];
        }];
    }else{
        self.scrollView.hidden = YES;
        self.authenView.hidden = YES;
    }
}

- (void)refreshUIWithMessage:(NSString *)message success:(BOOL)success {
    
    NSString *title = success ? @"指纹验证成功":@"指纹验证失败";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) this  = self;
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            this.authenView.hidden = success;
            this.scrollView.hidden  = !success;
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}

#pragma mark - 懒加载
-(WZLocalAuthentication *)authentication{
    if (!_authentication) {
        _authentication = [[WZLocalAuthentication alloc]init];
    }
    return _authentication;
}

-(WZAuthenView *)authenView{
    if (!_authenView) {
        __weak typeof(self) this  = self;
        _authenView = [[WZAuthenView alloc]initWithFrame:self.view.bounds];
        [_authenView setTouchAuthBlock:^{
            [this wz_authentication];
        }];
    }
    return _authenView;
}

-(UIView *)itemView{
    if (!_itemView) {
        _itemView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W / 6, 0, 2 * SCREEN_W/3, 40)];
    }
    return _itemView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_W *2, 0);
    }
    return _scrollView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

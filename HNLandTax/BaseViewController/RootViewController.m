//
//  RootViewController.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIGestureRecognizerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 侧滑返回
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.banSlidingBack) {
        return NO;
    }else{
        return self.navigationController.viewControllers.count > 1;
    }
}


#pragma mark - 设置父类导航
-(void)setSuperNavnavigation{
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers.count>1) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem.title = @"返回";
        //        self.navigationItem.leftItemsSupplementBackButton = YES;
        //        self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"backImageName"];
        //        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"backImageName"];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    [self findHiddenShadowImage];
}




#pragma mark - barButtonItem left && right

- (void)jm_createRightBarButtonItemWithImage:(NSString *)imageName{
    NSAssert(imageName.length>0,@"图片名称不能为空");
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItemWithImage:imageName];
}

- (void)jm_createRightBarButtonItemWithTitle:(NSString *)title{
    NSAssert(title.length>0,@"title 不能为空");
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItemWithTitle:title];
}

- (void)jm_createLeftBarButtonItemWithImage:(NSString *)imageName{
    NSAssert(imageName.length>0,@"图片名称不能为空");
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItemWithImage:imageName];
}

- (void)jm_createLeftBarButtonItemWithTitle:(NSString *)title{
    NSAssert(title.length>0,@"title 不能为空");
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItemWithTitle:title];
}


- (UIBarButtonItem *)leftBarButtonItemWithImage:(NSString *)imageName{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(jm_leftBarButtonItemAction:)];
    return barButtonItem;
    
}
- (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(jm_leftBarButtonItemAction:)];
    return barButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItemWithImage:(NSString *)imageName{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(jm_rightBarButtonItemAction:)];
    return barButtonItem;
    
}

- (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(jm_rightBarButtonItemAction:)];
    return barButtonItem;
}

- (void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    
}

- (void)jm_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - image handle
-(void)cameraOrAlbumObtainPhoto:(UIImage *)image{
    
}
-(void)photoToSave{
    
}

#pragma mark - 隐藏导航栏 shadow image
-(BOOL)jm_hiddenNavShadowImage{
    return YES;
}

-(void)findHiddenShadowImage{
    UIImageView *iv = [self findShadowImage:self.navigationController.navigationBar];
    iv.hidden = [self jm_hiddenNavShadowImage];
}

-(UIImageView *)findShadowImage:(UIView *)aView{
    if ([aView isKindOfClass:[UIImageView class]] && aView.bounds.size.height <= 1) {
        return (UIImageView *)aView;
    }
    for (UIView *view in aView.subviews) {
        UIImageView *iv =  (UIImageView *)[self findShadowImage:view];
        if (iv) {
            return iv;
        }
    }
    return  nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

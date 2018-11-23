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
}

#pragma mark - image handle
-(void)cameraOrAlbumObtainPhoto:(UIImage *)image{
    
}
-(void)photoToSave{
    
}

//#pragma mark - 隐藏导航栏 shadow image
//-(BOOL)jm_hiddenNavShadowImage{
//    return YES;
//}
//
//-(void)findHiddenShadowImage{
//    UIImageView *iv = [self findShadowImage:self.navigationController.navigationBar];
//    iv.hidden = [self jm_hiddenNavShadowImage];
//}
//
//-(UIImageView *)findShadowImage:(UIView *)aView{
//    if ([aView isKindOfClass:[UIImageView class]] && aView.bounds.size.height <= 1) {
//        return (UIImageView *)aView;
//    }
//    for (UIView *view in aView.subviews) {
//        UIImageView *iv =  (UIImageView *)[self findShadowImage:view];
//        if (iv) {
//            return iv;
//        }
//    }
//    return  nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

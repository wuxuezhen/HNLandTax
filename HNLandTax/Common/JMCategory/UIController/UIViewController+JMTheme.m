//
//  UIViewController+JMTheme.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/6/18.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "UIViewController+JMTheme.h"
#import "UIImage+ImageExtent.h"
@implementation UIViewController (JMTheme)


-(void)jm_naviShadowImageHidden:(BOOL)hidden{
    if (hidden) {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        if (@available(iOS 11.0, *)) {
            
        }else{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                          forBarMetrics:UIBarMetricsDefault];
        }
    }else{
        self.navigationController.navigationBar.shadowImage = [UIImage navShadowImage];
    }
}


-(void)jm_setNavigationBarWithAlpha:(CGFloat)alpha{
    [self jm_naviShadowImageHidden: YES];
    self.navigationController.navigationBar.translucent = YES;
    UIImage *image = [UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent: alpha]];
    [self.navigationController.navigationBar setBackgroundImage:alpha == 0 ? [UIImage new] :image
                                                  forBarMetrics:UIBarMetricsDefault];
}
@end

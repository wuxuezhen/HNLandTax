//
//  JMTabBarViewController.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/20.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMTabBarViewController.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "MineViewController.h"
#import "UIColor+JMColor.h"

#import "UITabBar+RedPoint.h"
#import "JMNavigationViewController.h"

@interface JMTabBarViewController ()

@end

@implementation JMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    [self setController];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateBadge)
//                                                 name:kNoReceiveRedbagCountNotification
//                                               object:nil];
}

- (void)updateBadge {
//    NSInteger totalUnread = [[JMUserInfoNet manager] noReceiveRedbagCount];
//    if (totalUnread > 0) {
//        [self.tabBar showBadgeOnItemIndex:4];
//    }else{
//        [self.tabBar hideBadgeOnItemIndex:4];
//    }
}



//主题风格
-(void)setupAppearance{
    
    //1.设置标签栏样式
    UITabBar *tabar = [UITabBar appearance];
    //标签栏颜色
    [tabar setBarTintColor:[UIColor whiteColor]];
    //标签栏透明度
    tabar.translucent = NO;
    //标签栏的前景色:
    //tabar.tintColor = [UIColor redColor];
    //标签栏Item的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor jm_themeColor]}
                                             forState:UIControlStateSelected];
    
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.shadowImage = [UIImage new];
    //导航栏颜色
//    navBar.barTintColor = [UIColor jm_themeColor];
    //导航栏按钮颜色
//    navBar.tintColor = [UIColor blackColor];
    //导航栏样式
//    navBar.barStyle = UIBarStyleBlack;
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //导航栏是否透明度
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f) {
        navBar.translucent = YES;
    }else{
        navBar.translucent = NO;
    }
    //导航栏设置标题文字显示样式
//    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
//    [navBar setBackgroundImage:[[UIImage alloc] init]
//                forBarPosition:UIBarPositionAny
//                    barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //此处使底部线条颜色为红色
    [navBar setShadowImage:[UIImage new]];
    
}

//创建标签控制器
-(void)setController{
    NSArray *classes = @[[HomeViewController class],
                         [FindViewController class],
                         [MineViewController class]];
    
    NSArray *titles = @[@"首页",@"发现",@"个人"];
    NSArray *unselectImages = @[@"tabbar_motion_n",@"tabbar_find_n",@"tabbar_personal_n"];
    NSArray *selectImages = @[@"tabbar_motion_s",@"tabbar_find_s",@"tabbar_personal_s"];
    for (NSInteger i = 0; i<titles.count; i++) {
        //使用数组中存放类创建的对象
        
        UIViewController *vc= [[classes[i] alloc]init];
        vc.title = titles[i];
        JMNavigationViewController *nav = [[JMNavigationViewController alloc]initWithRootViewController:vc];
        //未选中图片
        nav.tabBarItem.image = [UIImage imageNamed:unselectImages[i]];
        nav.tabBarItem.image = [nav.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中图片
        nav.tabBarItem.selectedImage = [UIImage imageNamed:selectImages[i]];
        //设置图片为原色渲染
        nav.tabBarItem.selectedImage = [nav.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //标签栏上的item的标题
        nav.tabBarItem.title = titles[i];

        [self addChildViewController:nav];
        //设置标签徽记
        //nav.tabBarItem.badgeValue = @"NEW";
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

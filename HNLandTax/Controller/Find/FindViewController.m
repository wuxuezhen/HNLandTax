//
//  FindViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "FindViewController.h"
#import "FTTViewController.h"
#import "JMWeidu.h"
#define kOpenRefreshHeaderViewHeight 0

@interface FindViewController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakVC = self;
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger refreshPage = weakVC.pageIndex;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            /// 取到之前的页面进行刷新 pageIndex 是当前页面
            FTTViewController *vc2 = weakVC.controllersM[refreshPage];
            [vc2.tableView reloadData];
            
            if (kOpenRefreshHeaderViewHeight) {
                weakVC.headerView.yn_height = 300;
                [weakVC.bgScrollView.mj_header endRefreshing];
                [weakVC reloadSuspendHeaderViewFrame];
            } else {
                [weakVC.bgScrollView.mj_header endRefreshing];
            }
        });
    }];
}

-(instancetype)init{
    self = [FindViewController suspendTopPausePageVC];
    if (self) {
    }
    return self;
}

+ (instancetype)suspendTopPausePageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTop;
    configration.headerViewCouldScale = NO;
    configration.showTabbar = YES;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    configration.lineColor = [UIColor blueColor];
    configration.scrollViewBackgroundColor = [UIColor lightGrayColor];
    FindViewController *vc = [FindViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                            titles:[self getArrayTitles]
                                                                            config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 300)];
    headerView.backgroundColor = [UIColor redColor];
    vc.headerView = headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    return vc;
}

+ (NSArray *)getArrayVCs {
    FTTViewController *vc_1 = [[FTTViewController alloc] init];
    FTTViewController *vc_2 = [[FTTViewController alloc] init];
    FTTViewController *vc_3 = [[FTTViewController alloc] init];
    return @[vc_1, vc_2, vc_3];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}

#pragma mark - Private Function

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    FTTViewController *vc = pageViewController.controllersM[index];
    return vc.tableView;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


@end




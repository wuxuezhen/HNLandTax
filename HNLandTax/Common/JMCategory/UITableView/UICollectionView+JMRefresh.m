//
//  UICollectionView+JMRefresh.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/11.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "UICollectionView+JMRefresh.h"

#import "JMRefreshNormalHeader.h"
#import "JMRefreshnAutoNormalFooter.h"

@implementation UICollectionView (JMRefresh)

-(void)jm_headerRefreshTarget:(id)target selecter:(SEL)selecter{
    self.mj_header = [JMRefreshNormalHeader headerWithRefreshingTarget:target
                                                      refreshingAction:selecter];
}
-(void)jm_footerRefreshTarget:(id)target selecter:(SEL)selecter{
    self.mj_footer = [JMRefreshnAutoNormalFooter footerWithRefreshingTarget:target
                                                           refreshingAction:selecter];
}


-(void)endRefreshAllLoad:(BOOL)loaded{
    if (loaded) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    [self endRefresh];
}
-(void)endRefresh{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
    [self reloadData];
}
@end



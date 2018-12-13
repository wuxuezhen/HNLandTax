//
//  UITableView+BDRefresh.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/11.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "UITableView+BDRefresh.h"
#import "BDRefreshNormalHeader.h"
#import "BDRefreshnAutoNormalFooter.h"

@implementation UITableView (BDRefresh)

-(void)bd_headerRefreshTarget:(id)target selecter:(SEL)selecter{
    self.mj_header = [BDRefreshNormalHeader headerWithRefreshingTarget:target
                                                      refreshingAction:selecter];
}
-(void)bd_footerRefreshTarget:(id)target selecter:(SEL)selecter{
    self.mj_footer = [BDRefreshnAutoNormalFooter footerWithRefreshingTarget:target
                                                           refreshingAction:selecter];
}


-(void)endRefreshAllLoad:(BOOL)loaded{
    if (loaded) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    [self endRefreshForHeader];
    [self reloadData];
}

-(void)endRefresh{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
        self.mj_footer.state = MJRefreshStateIdle;
    }
    [self endRefreshForFooter];
    [self reloadData];
}

-(void)endRefreshForHeader{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
}

-(void)endRefreshForFooter{
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}

@end


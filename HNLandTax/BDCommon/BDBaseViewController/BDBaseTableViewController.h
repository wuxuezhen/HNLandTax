//
//  BDBaseTableViewController.h
//
//  Created by 吴振振 on 2017/11/30.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "RootViewController.h"
#import "BDBaseProtocol.h"
@interface BDBaseTableViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,BDTableViewProtocol,BDRefreshProtocol,BDNetConfigProtocol>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

-(void)bd_noInsetAdjustmentBehavior;

@end

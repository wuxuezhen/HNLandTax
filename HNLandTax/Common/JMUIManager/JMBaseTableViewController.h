//
//  JMBaseTableViewController.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/11/30.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "RootViewController.h"
#import "JMWeiDu.h"
@interface JMBaseTableViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

#pragma mark - 创建tableView
-(void)jm_tableViewDefaut;

-(void)jm_tableViewForFill;


#pragma mark - 分页刷新
/** 分页刷新 包含上拉，下拉 事件已经实现 **/
-(void)mj_pageRefresh;

/** 分页刷新 包含上拉事件已经实现 **/
-(void)mj_pageRefreshForFooter;

/** 分页刷新 包含下拉事件已经实现 **/
-(void)mj_pageRefreshForHeader;

#pragma mark - 普通刷新 需要实现上拉，下拉事件
/** 普通刷新 需要实现上拉，下拉事件**/
-(void)mj_refresh;

/** MJHeader刷新 需要实现下拉事件**/
-(void)mj_headerRefresh;

/** MJFooter刷新 需要实现上拉事件**/
-(void)mj_footerRefresh;

/** 下拉事件**/
-(void)mj_headerRefreshAction;

/** 上拉事件**/
-(void)mj_footerRefreshAction;

/** 第一次下拉刷新 需要调用下来刷新**/
-(void)jm_beginLoadRequest;

/** 刷新数据 **/
-(void)jm_refreshData;

#pragma mark - 配置tableView
/** tableView的风格 默认plain **/
-(UITableViewStyle)tableViewStyle;

#pragma mark - 配置Config
/** 分页请求的URL **/
-(NSString *)jm_pageUrl;

/** 数据解析key **/
-(NSString *)jm_parsingKey;

/** 分页请求的params 参数 **/
-(NSDictionary *)jm_params;

/** 数据转型后得到model类 **/
-(Class)jm_pageModelClass;


-(void)wz_noInsetAdjustmentBehavior;

@end

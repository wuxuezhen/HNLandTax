//
//  JMBaseTableViewController.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/11/30.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "JMBaseTableViewController.h"
#import "UITableView+JMRefresh.h"
#import "JMPageNetModel.h"
@interface JMBaseTableViewController ()
@property (nonatomic, strong) JMPageNetModel *pageNet;
@end

@implementation JMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view.
}

#pragma mark - 默认创建
-(void)jm_tableViewDefaut{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

#pragma mark - 全屏创建
-(void)jm_tableViewForFill{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
}

-(void)wz_noInsetAdjustmentBehavior{
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout =  UIRectEdgeAll;
}

#pragma mark -  Page MJRefresh
-(void)mj_pageRefresh{
    [self.tableView jm_headerRefreshTarget:self.pageNet selecter:@selector(getFirstPage)];
    [self.tableView jm_footerRefreshTarget:self.pageNet selecter:@selector(getNextPage)];
}

-(void)mj_pageRefreshForHeader{
    [self.tableView jm_headerRefreshTarget:self.pageNet selecter:@selector(getFirstPage)];
}
-(void)mj_pageRefreshForFooter{
    [self.tableView jm_footerRefreshTarget:self.pageNet selecter:@selector(getNextPage)];
}


#pragma mark - MJRefresh

- (void)mj_refresh {
    [self mj_headerRefresh];
    [self mj_footerRefresh];
}

-(void)mj_headerRefresh{
    [self.tableView jm_headerRefreshTarget:self selecter:@selector(mj_headerRefreshAction)];
}

-(void)mj_footerRefresh{
    [self.tableView jm_footerRefreshTarget:self selecter:@selector(mj_footerRefreshAction)];
}

-(void)mj_headerRefreshAction{
    
}
-(void)mj_footerRefreshAction{
    
}

-(void)jm_beginLoadRequest{
    [self.tableView.mj_header beginRefreshing];
}

-(UITableViewStyle)tableViewStyle{
    return UITableViewStylePlain;
}

#pragma mark - Net Config
-(NSString *)jm_pageUrl{
    return nil;
}
-(Class)jm_pageModelClass{
    return nil;
}
-(NSDictionary *)jm_params{
    return nil;
}
-(NSString *)jm_parsingKey{
    return nil;
}

-(void)jm_refreshData{
    [self.pageNet refreshParams:[self jm_params]];
}


#pragma mark - UITableViewDeletage

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]init];
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JMUI createTableViewWith:CGRectZero target:self style:[self tableViewStyle]];
        _tableView.separatorColor = JM_RGB_HEX(0xcccccc);
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}


- (JMPageNetModel *)pageNet {
    if (!_pageNet) {
        NSString *url      = [self jm_pageUrl];
        NSString *key      = [self jm_parsingKey];
        NSDictionary *para = [self jm_params];
        Class class        = [self jm_pageModelClass];
        
        if (para) {
            _pageNet = [[JMPageNetModel alloc] initWithJSONModelClass:class
                                                                  key:key
                                                              apiPath:url
                                                               params:para];
        }else{
            _pageNet = [[JMPageNetModel alloc] initWithJSONModelClass:class
                                                                  key:key
                                                              apiPath:url];
        }
        
        __weak typeof(self) wself = self;
        
        _pageNet.RefreshHandler = ^{
            __strong typeof(self) strongSelf = wself;
            if (strongSelf) {
                if (!strongSelf.dataArray) {
                    strongSelf.dataArray = [NSMutableArray array];
                } else {
                    [strongSelf.dataArray removeAllObjects];
                    // [strongSelf.tableView reloadData];
                }
            }
        };
        
        _pageNet.AllDownloadedHandler = ^{
            __strong typeof(self) strongSelf = wself;
            if (strongSelf) {
                [strongSelf.tableView endRefreshAllLoad:YES];
            }
        };
        
        _pageNet.ErrorHandler = ^(NSError *error) {
            __strong typeof(self) strongSelf = wself;
            if (strongSelf) {
                [strongSelf.tableView endRefresh];
            }
        };
        
        _pageNet.NextPageHandler = ^(NSArray *results) {
            __strong typeof(self) strongSelf = wself;
            if (strongSelf) {
                [strongSelf.dataArray addObjectsFromArray:results];
                
                [strongSelf.tableView endRefresh];
            }
        };
    }
    return _pageNet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

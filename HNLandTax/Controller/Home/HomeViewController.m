//
//  HomeViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HomeViewController.h"
#import "HDetailViewController.h"
#import "HomeTableViewCell.h"
#import "JMJsonHandle.h"
#import "JMWeiDu.h"
#import "WZVideo.h"
#import "WZAuthenView.h"
#import "WZLocalAuthentication.h"
#import "UIViewController+JMTheme.h"
#define path_local @"/Users/wuzhenzhen/Desktop/video/vv.plist"
@interface HomeViewController ()
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *videoUrls;
@property (nonatomic, strong) NSMutableArray *deleteUrls;
@property (nonatomic, strong) WZLocalAuthentication *authentication;
@property (nonatomic, strong) WZAuthenView *authenView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wz_initUI];
    [self wz_authentication];
}

-(void)wz_initUI{
    self.videoUrls  = [NSMutableArray arrayWithCapacity:0];
    self.deleteUrls = [NSMutableArray arrayWithCapacity:0];
    [self fit_createRightBarButtonItemWithTitle:@"添加"];
    [self fit_createLeftBarButtonItemWithTitle:@"编辑"];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"video"];
    NSArray *deleteArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"deleteVideo"];
    if (arr && arr.count > 0) {
        [self.videoUrls addObjectsFromArray:arr];
    }
    
    NSArray *urls = [JMJsonHandle toObjectWithJsonPath:@"video"];
    
    for (NSString *url in urls) {
        if (![self.videoUrls containsObject:url]) {
            [self.videoUrls addObject:url];
        }
    }
    
    for (WZVideo *video in deleteArr) {
        if (![self.videoUrls containsObject:video.videoUrl]) {
            [self.videoUrls removeObject:video.videoUrl];
        }
    }
    
    [self.videoUrls sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    [self resetData];
    
    [self WZLog];
    
    if (@available(iOS 11.0, *)) {
        //        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        self.navigationItem.searchController = self.searchController;
    } else {
        // Fallback on earlier versions
    }
    [self.tableView registerNib:[HomeTableViewCell nib]
         forCellReuseIdentifier:[HomeTableViewCell reuseIdentifier]];
    [self jm_tableViewDefaut];
    
}

-(void)resetData{
    for (NSString *url in self.videoUrls) {
        WZVideo *video = [WZVideo new];
        video.videoUrl = url;
        [self.dataArray addObject:video];
    }
}

-(void)WZLog{
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in self.videoUrls) {
        [str appendFormat:@"\"%@\",",key];
    }
    NSLog(@"str = %@",[str substringToIndex:str.length-1]);
}


-(void)wz_authentication{
    if ([self.authentication wz_canEvaluatePolicy]) {
        __weak typeof(self) this  = self;
        [self.authentication wz_evaluatePolicy:^(BOOL success, NSString * _Nullable message) {
            [this refreshUIWithMessage:message success:success];
        }];
    }else{
        self.authenView.hidden = YES;
    }
}



- (void)refreshUIWithMessage:(NSString *)message success:(BOOL)success {
    
    NSString *title = success ? @"指纹验证成功":@"指纹验证失败";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) this  = self;
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
            this.authenView.hidden = success;
        });
    }];
    
}


-(void)fit_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    self.tableView.editing = !self.tableView.editing;
    barButtonItem.title = self.tableView.editing ? @"取消" : @"编辑";
}

-(void)fit_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    NSString *text = self.searchController.searchBar.text;
    if (text.length > 0) {
        [self.videoUrls insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.videoUrls forKey:@"video"];
        [self resetData];
        [self.tableView reloadData];
        self.searchController.searchBar.text = nil;
    }
}

-(NSURL *)localUrl:(NSString *)key{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *url  = [path stringByAppendingPathComponent:key];
    return [NSURL fileURLWithPath:url];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.row
                        withObjectAtIndex:destinationIndexPath.row];
    [tableView moveRowAtIndexPath:sourceIndexPath
                      toIndexPath:destinationIndexPath];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    WZVideo *video = self.dataArray[indexPath.row];
    [video wz_removeObjectForKey];
    [self.deleteUrls addObject:video];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.videoUrls removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSUserDefaults standardUserDefaults] setObject:self.videoUrls forKey:@"video"];
    [[NSUserDefaults standardUserDefaults] setObject:self.deleteUrls forKey:@"deleteVideo"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell reuseIdentifier]];
    cell.video = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HDetailViewController *h = [[HDetailViewController alloc]init];
    h.video = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:h animated:YES];
}

-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchController.searchBar.placeholder = @"请输入视频URL,添加到播放列表";
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.showsCancelButton = NO;
    }
    return _searchController;
}

-(WZLocalAuthentication *)authentication{
    if (!_authentication) {
        _authentication = [[WZLocalAuthentication alloc]init];
    }
    return _authentication;
}

-(WZAuthenView *)authenView{
    if (!_authenView) {
        __weak typeof(self) this  = self;
        _authenView = [[WZAuthenView alloc]initWithFrame:self.view.bounds];
        [_authenView setTouchAuthBlock:^{
            [this wz_authentication];
        }];
    }
    return _authenView;
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

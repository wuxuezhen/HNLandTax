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
#import "WZLocalAuthentication.h"

#define path_local @"/Users/wuzhenzhen/Desktop/video/vv.plist"
@interface HomeViewController ()
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *videoUrls;
@property (nonatomic, strong) WZLocalAuthentication *authentication;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wx_initUI];
    self.tableView.hidden = YES;
    self.authentication = [[WZLocalAuthentication alloc]init];
    __weak typeof(self) this  = self;
    [self.authentication wz_evaluatePolicy:^(BOOL success, NSString * _Nullable message, NSError * _Nullable error) {
        if (success) {
            self.tableView.hidden = NO;
        }
    }];
}

-(void)wx_initUI{
    self.videoUrls = [NSMutableArray arrayWithCapacity:0];
    [self fit_createRightBarButtonItemWithTitle:@"添加"];
    [self fit_createLeftBarButtonItemWithTitle:@"编辑"];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"video"];
    if (arr && arr.count > 0) {
        [self.videoUrls addObjectsFromArray:arr];
    }
    
    NSArray *urls = [JMJsonHandle toObjectWithJsonPath:@"video"];
    
    for (NSString *url in urls) {
        if (![self.videoUrls containsObject:url]) {
            [self.videoUrls addObject:url];
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

-(void)jm_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    self.tableView.editing = !self.tableView.editing;
    barButtonItem.title = self.tableView.editing ? @"取消" : @"编辑";
}

-(void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
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
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.videoUrls removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSUserDefaults standardUserDefaults] setObject:self.videoUrls forKey:@"video"];
    
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
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

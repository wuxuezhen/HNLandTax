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
#import "JMWeiDu.h"
#define path_local @"/Users/wuzhenzhen/Desktop/video/vv.plist"
@interface HomeViewController ()
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self jm_createRightBarButtonItemWithTitle:@"添加"];
    [self jm_createLeftBarButtonItemWithTitle:@"编辑"];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"video"];
    if (arr && arr.count > 0) {
        [self.dataArray addObjectsFromArray:arr];
    }
    NSArray *urls = [self jsontoArray:@"video"];
    for (NSString *url in urls) {
        if (![self.dataArray containsObject:url]) {
            [self.dataArray addObject:url];
        }
    }
    
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
-(void)jm_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    self.tableView.editing = !self.tableView.editing;
    barButtonItem.title = self.tableView.editing ? @"取消" : @"编辑";
}

-(void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    NSString *text = self.searchController.searchBar.text;
    if (text.length > 0) {
        [self.dataArray insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:@"video"];
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
    NSString *url = self.dataArray[indexPath.row];
    NSString *key = url.lastPathComponent;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    NSString *path = [self localUrl:key].path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:@"video"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell reuseIdentifier]];
    cell.path = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HDetailViewController *h = [[HDetailViewController alloc]init];
    h.url = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:h animated:YES];
}

-(NSArray *)jsontoArray:(NSString *)string{
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return array;
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

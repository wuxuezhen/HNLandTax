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
#import "JMCoreDataManager.h"
#import "AddDataViewController.h"


#define path_local @"/Users/wuzhenzhen/Desktop/video/vv.plist"
@interface HomeViewController ()
@property (nonatomic, strong) WZLocalAuthentication *authentication;
@property (nonatomic, strong) WZAuthenView *authenView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wz_initUI];
    [self wz_authentication];
}
-(void)wz_authentication{
    if ([self.authentication wz_canEvaluatePolicy]) {
        __weak typeof(self) this  = self;
        [self.authentication wz_evaluatePolicy:^(BOOL success, NSString * _Nullable message) {
            [this refreshUIWithMessage:message success:success];
        }];
    }else{
        self.tableView.hidden = YES;
        self.authenView.hidden = YES;
    }
}


-(void)wz_initUI{
    [self fit_createRightBarButtonItemWithTitle:@"添加"];
    [self fit_createLeftBarButtonItemWithTitle:@"编辑"];
    [self initData];
    [self resetData];
    [self WZLog];
    
    [self.tableView registerNib:[HomeTableViewCell nib]
         forCellReuseIdentifier:[HomeTableViewCell reuseIdentifier]];
    [self jm_tableViewDefaut];
    self.tableView.hidden = YES;
    
}

-(void)initData{
    NSArray *urls = [JMJsonHandle toObjectWithJsonPath:@"video"];
    for (NSString *url in urls) {
        WZVideo *video = [WZVideo new];
        video.videoUrl = url;
        [self.dataArray addObject:video];
    }
}

-(void)resetData{
    NSArray *arr = [self switchDataWithArray:[[JMCoreDataManager manager] sortAllData]];
    for (WZVideo *video in arr) {
        WZVideo *temp = [self getVideoWithUrl:video.videoUrl];
        if (temp) {
            [self.dataArray removeObject:temp];
        }
        if (!video.isDelete) {
            [self.dataArray addObject:video];
        }
    }
}

-(WZVideo *)getVideoWithUrl:(NSString *)url{
    WZVideo *video = nil;
    for (WZVideo *obj in self.dataArray) {
        if ([obj.videoUrl isEqualToString:url]) {
            video = obj;
            break;
        }
    }
    return video;
}

-(NSArray *)switchDataWithArray:(NSArray *)array{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    for (JMVideo *video in array) {
        WZVideo *obj = [[WZVideo alloc]init];
        obj.name = video.name;
        obj.videoUrl = video.videoUrl;
        obj.isDelete = video.isDelete;
        [results addObject:obj];
    }
    return results;
}

-(void)WZLog{
    NSMutableString *str = [NSMutableString string];
    for (WZVideo *key in self.dataArray) {
        [str appendFormat:@"\"%@\",",key.videoUrl];
    }
    NSLog(@"str = %@",[str substringToIndex:str.length-1]);
}


- (void)refreshUIWithMessage:(NSString *)message success:(BOOL)success {
    
    NSString *title = success ? @"指纹验证成功":@"指纹验证失败";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) this  = self;
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            this.authenView.hidden = success;
            this.tableView.hidden  = !success;
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}


-(void)fit_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    self.tableView.editing = !self.tableView.editing;
    barButtonItem.title = self.tableView.editing ? @"取消" : @"编辑";
}

-(void)fit_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    AddDataViewController *add = [[AddDataViewController alloc]init];
    __weak typeof(self) this = self;
    add.addVideoSuccess = ^{
        [this resetData];
        [this.tableView reloadData];
    };
    [self.navigationController pushViewController:add animated:YES];
    
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
    video.isDelete = YES;
    [video wz_removeObjectForKey];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[JMCoreDataManager manager] updateData:video];
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

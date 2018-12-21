//
//  DeletedViewController.m
//  HNLandTax
//
//  Created by wzz on 2018/12/21.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "DeletedViewController.h"
#import "HDetailViewController.h"
#import "HomeTableViewCell.h"
#import "JMCoreDataManager.h"


@interface DeletedViewController ()
@end

@implementation DeletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wz_initUI];
}

-(void)wz_initUI{
    [self initData];
    [self.tableView registerNib:[HomeTableViewCell nib]
         forCellReuseIdentifier:[HomeTableViewCell reuseIdentifier]];
    [self jm_tableViewDefaut];
}

-(void)initData{
    [self resetData];
}

-(void)resetData{
    NSArray *arr = [self switchDataWithArray:[[JMCoreDataManager manager] sortAllData]];
    for (WZVideo *video in arr) {
        if (video.isDelete) {
            [self.dataArray addObject:video];
        }
    }
    [self.tableView reloadData];
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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    WZVideo *video = self.dataArray[indexPath.row];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[JMCoreDataManager manager] deleteData:video.videoUrl];
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

@end


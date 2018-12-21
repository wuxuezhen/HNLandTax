//
//  DownloadViewController.m
//  HNLandTax
//
//  Created by wzz on 2018/12/21.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "DownloadViewController.h"
#import "HDetailViewController.h"
#import "HomeTableViewCell.h"
#import "JMJsonHandle.h"
#import "JMCoreDataManager.h"

@interface DownloadViewController ()
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wz_initUI];
}

-(void)wz_initUI{
    [self initData];
    [self resetData];
    [self WZLog];
    
    [self.tableView registerNib:[HomeTableViewCell nib]
         forCellReuseIdentifier:[HomeTableViewCell reuseIdentifier]];
    [self jm_tableViewDefaut];
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
    [self.tableView reloadData];
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

@end


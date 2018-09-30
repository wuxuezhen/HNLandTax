//
//  FTTViewController.m
//  HNLandTax
//
//  Created by caiyi on 2018/9/30.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "FTTViewController.h"

@interface FTTViewController ()

@end

@implementation FTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 100; i ++) {
        [self.dataArray addObject:@"11ddd"];
    }
    [self jm_tableViewDefaut];
   
    // Do any additional setup after loading the view.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"我是cell";
    return cell;
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

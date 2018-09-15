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
@interface HomeViewController ()
@property (nonatomic, strong) UITextField *text;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"video"];
    if (arr && arr.count > 0) {
        [self.dataArray addObjectsFromArray:arr];
    }
    
    NSArray *urls = @[@"https://mp4.238yy.com/javbox-mp4/n1273.mp4",
                      @"https://mp4.238yy.com/javbox-mp4/TP-23410.mp4",
                      @"https://mp4.238yy.com/javbox-mp4/121917_619-1pon.mp4",
                      @"https://mp4.238yy.com/javbox-mp4/121917_189-paco.mp4",
                      @"https://mp4.238yy.com/javbox-mp4/121917_01-10mu.mp4"];
    for (NSString *url in urls) {
        if (![self.dataArray containsObject:url]) {
            [self.dataArray addObject:url];
        }
    }
   
    [self jm_createRightBarButtonItemWithTitle:@"添加"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    view.backgroundColor = JM_RGB_HEX(0xf1f1f1);
    [view addSubview:self.text];
    self.tableView.tableHeaderView = view;
    [self.tableView registerNib:[HomeTableViewCell nib]
         forCellReuseIdentifier:[HomeTableViewCell reuseIdentifier]];
    [self jm_tableViewDefaut];
}

-(void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    if (self.text.text.length > 0) {
        [self.dataArray addObject:self.text.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:@"video"];
        [self.tableView reloadData];
        self.text.text = nil;
    }
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITextField *)text{
    if (!_text) {
        _text = [[UITextField alloc]initWithFrame:CGRectMake(15, 8, SCREEN_W-30, 34)];
        _text.borderStyle = UITextBorderStyleRoundedRect;
        _text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _text.textColor = [UIColor blackColor];
        _text.tintColor = [UIColor blackColor];
        _text.font = [UIFont systemFontOfSize:14];
    }
    return _text;
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

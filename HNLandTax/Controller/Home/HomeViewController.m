//
//  HomeViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HomeViewController.h"
#import "DownloadTool.h"
@interface HomeViewController ()
@property (nonatomic, strong) DownloadTool *tool;
@property (nonatomic, copy) NSString *path;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(sss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打开" style:UIBarButtonItemStylePlain target:self action:@selector(sss)];
}


-(void)sss{
    [self.tool downLoadWithDownloadUrl:_tool.downloadUrl success:^(NSString *fliePath) {
        self.path = fliePath;
    } progress:^(double progress) {
        NSLog(@"progress = %@",@(progress).stringValue);
    }];
}

-(DownloadTool *)tool{
    if (!_tool) {
        _tool = [[DownloadTool alloc]init];
        _tool.downloadUrl = @"http://oojvynd5j.bkt.clouddn.com/record5b8963dc27deb1535730652.pdf";
    }
    return _tool;
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

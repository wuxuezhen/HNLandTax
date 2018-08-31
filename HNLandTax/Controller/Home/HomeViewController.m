//
//  HomeViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "LDWebViewViewController.h"
@interface HomeViewController ()
@property (nonatomic, copy) NSString *path;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(ddd)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打开" style:UIBarButtonItemStylePlain target:self action:@selector(sss)];
  
}

-(void)sss{
    LDWebViewViewController *webViewVC = [[LDWebViewViewController alloc] init];
    webViewVC.stringURL = [self getPath].path;
    
    [self.navigationController pushViewController:webViewVC animated:YES];
}

-(void)ddd{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:@"http://oojvynd5j.bkt.clouddn.com/record5b8963dc27deb1535730652.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
   
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            double progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            NSLog(@"progress = %@",@(progress).stringValue);
            
        }];

    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [weakSelf getPath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
        weakSelf.path = filePath.path;
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
}

-(NSURL *)getPath{
    NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [path URLByAppendingPathComponent:@"60652.pdf"];
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

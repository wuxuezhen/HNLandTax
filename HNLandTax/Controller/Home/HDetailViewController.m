//
//  HDetailViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/9/10.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HDetailViewController.h"
#import "FITDownSession.h"
#import "HAVPlayerViewController.h"
#import "HZPlayerViewController.h"
#import "JMCacheManager.h"
#import "APPDevice.h"
#import "JMWeiDu.h"
@interface HDetailViewController ()
@property (nonatomic, strong) FITDownSession *session;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) NSURL *localUrl;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation HDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self jm_createRightBarButtonItemWithTitle:@"删除"];
    self.key = self.url.lastPathComponent;
    self.localPath = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
    self.isDown = self.localPath && self.localPath.length > 0 ? YES :NO;
    if (self.isDown ) {
        self.localUrl = [NSURL fileURLWithPath:self.localPath];
        self.stateLabel.text = @"已下载";
        self.progressView.progress = 1;
        self.progressLabel.text = @"100%";
    }else{
        self.progressLabel.text = @"0%";
        self.progressView.progress = 0;
        self.stateLabel.text = @"未下载";
    }
    self.nameLabel.text = self.url;
    
}
-(void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.key];
    [[NSFileManager defaultManager] removeItemAtPath:self.localPath error:nil];
}
- (IBAction)down:(id)sender {
    [self.session fit_downloadResume];
}
- (IBAction)play:(id)sender {
    if (self.isDown) {
        [self playVideo:self.localUrl];
    }else{
        [self playVideo:[NSURL URLWithString:self.url]];
    }
}
- (IBAction)zfPlay:(id)sender {
    HZPlayerViewController *play = [[HZPlayerViewController alloc]init];
    if (self.isDown) {
          play.url = self.localUrl;
    }else{
         play.url = [NSURL URLWithString:self.url];
    }
    [self.navigationController pushViewController:play animated:YES];
}
- (IBAction)cache:(id)sender {
    NSInteger size = [JMCacheManager jm_cacheSize];
    double diskspace = [APPDevice getFreeDiskspace] / 1024 / 1024 / 1024 ;
    
    NSString *message = size > 1000 ? [NSString stringWithFormat:@"%.2lf G",(double)size/1024]:[@(size).stringValue stringByAppendingString:@"M"];
    [self fit_showAlertWithTitle:@"提示"
                         message:[NSString stringWithFormat:@"缓存大小:%@ 剩余空间：%.2lf G",message,diskspace]
                   confirmAction:nil];
    
}

-(NSString *)getFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


-(FITDownSession *)session{
    if (!_session) {
        __weak typeof(self) this = self;
        _session = [[FITDownSession alloc] initWithDownloadUrl:self.url
                                                    identifier:self.url.lastPathComponent
                                               downloadHandler:^(FITDownLoadResponse *response) {
                                                   this.progressView.progress = response.progress;
                                                   this.progressLabel.text = [NSString stringWithFormat:@"%.2lf%%",response.progress * 100];
                                                   if (response.progress >= 1) {
                                                       [this save:response.downloadSaveFileUrl forkey:this.key];
                                                   }
                                               }];
    }
    return _session;
}

-(void)save:(NSURL *)url forkey:(NSString *)key{
    self.localUrl = url;
    [[NSUserDefaults standardUserDefaults] setObject:url.path forKey:key];
    self.isDown = YES ;
    self.stateLabel.text = @"已下载";
}

-(void)playVideo:(NSURL *)videoURL{
    HAVPlayerViewController * afterVC = [[HAVPlayerViewController alloc]init];
    AVPlayer * player = [AVPlayer playerWithURL:videoURL];
    afterVC.player = player;
    [self presentViewController:afterVC animated:YES completion:nil];
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

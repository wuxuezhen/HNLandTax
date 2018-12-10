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
#import "NSString+VideoSave.h"
#import "APPDevice.h"
#import "JMWeiDu.h"
#import "HUserManager.h"
@interface HDetailViewController ()<DownloadDelegate>
@property (nonatomic, strong) FITDownSession *session;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fit_createRightBarButtonItemWithTitle:@"分享"];
    
    if (self.video.isDownload ) {
        self.stateLabel.text = @"已下载";
        self.progressView.progress = 1;
        self.progressLabel.text = @"100%";
    }else{
        self.progressLabel.text = @"0%";
        self.progressView.progress = 0;
        self.stateLabel.text = @"未下载";
    }
    self.titleLabel.text = self.video.name ? :self.video.key;
    self.nameLabel.text = self.video.videoUrl;
    [self setVideoUrl:self.video.playURL];
    
    FITDownSession *session = [[HUserManager manager] taskForKey:self.video.key];
    if (session) {
        _session = session;
       self.session.delegate = self;
    }
    
}

-(void)fit_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    NSArray *activityItems = @[self.video.playURL];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed) {
            [JMTip showCenterWithText:@"分享成功"];
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)wz_download:(FITDownLoadResponse *)response{
    self.progressView.progress = response.progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2lf%%",response.progress * 100];
    if (response.progress >= 1) {
        [self save:response.downloadSaveFileUrl forkey:self.video.key];
    }
}

-(void)playVideo:(NSURL *)videoURL{
    HAVPlayerViewController * afterVC = [[HAVPlayerViewController alloc]init];
    AVPlayer * player = [AVPlayer playerWithURL:videoURL];
    afterVC.player = player;
    [self presentViewController:afterVC animated:YES completion:nil];
}

- (IBAction)down:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.session fit_downloadResume];
        [[HUserManager manager]addTask:self.session];
    }else{
        [[HUserManager manager] deleteTaskForKey:self.video.key];
        self.session.delegate = nil;
        self.session = nil;
    }
    
}

- (IBAction)play:(id)sender {
    [self playVideo:self.video.playURL];
}

- (IBAction)zfPlay:(id)sender {
    HZPlayerViewController *play = [[HZPlayerViewController alloc]init];
    play.url = self.video.playURL;
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

- (IBAction)saveToLocal:(id)sender {
    if (self.video.isDownload) {
        [self.video.localPath jm_saveVideoToAlbums];
    }else{
        [JMTip showCenterWithText:@"本地找不到文件"];
    }
}


#pragma mark - 获取视频第一帧
- (void)setVideoUrl:(NSURL *)url{
    UIImage *image = (UIImage *)[[HUserManager manager] getCacheObjectForKey:self.video.key];
    if (image) {
        self.photoView.image = image;
    }else{
        [self loadImageWithUrl:url forKey:self.video.key];
    }
}

-(void)loadImageWithUrl:(NSURL *)videoUrl forKey:(NSString *)key{
    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
        UIImage *image = [self getVideoPreViewImage:videoUrl];
        if (image) {
            [[HUserManager manager] cacheObject:image forKey:key];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.photoView.image = image;
            }];
        }
    }];
}


- (UIImage*) getVideoPreViewImage:(NSURL *)path{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(600, 600);
    NSError *error = nil;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:NULL error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

-(void)save:(NSURL *)url forkey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:url.path forKey:key];
    self.video.isDownload = YES ;
    self.stateLabel.text = @"已下载";
}

#pragma mark --- 懒加载
-(NSString *)getFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(FITDownSession *)session{
    if (!_session) {
        __weak typeof(self) this = self;
        _session = [[FITDownSession alloc] initWithDownloadUrl:self.video.videoUrl
                                                    identifier:self.video.key
                                               downloadHandler:^(FITDownLoadResponse *response) {
                                                   this.progressView.progress = response.progress;
                                                   this.progressLabel.text = [NSString stringWithFormat:@"%.2lf%%",response.progress * 100];
                                                   if (response.progress >= 1) {
                                                       [this save:response.downloadSaveFileUrl forkey:this.video.key];
                                                   }
                                               }];
    }
    return _session;
}

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

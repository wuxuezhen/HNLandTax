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
@interface HDetailViewController ()
@property (nonatomic, strong) FITDownSession *session;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (nonatomic, strong) NSURL *localUrl;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation HDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"删除"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(deleteVideo)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"分享"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(shareVideo)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    self.key = self.url.lastPathComponent;
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
    self.isDown = path && path.length > 0;
    
    NSURL *videoUrl = nil;
    if (self.isDown ) {
        self.stateLabel.text = @"已下载";
        self.progressView.progress = 1;
        self.progressLabel.text = @"100%";
        videoUrl = self.localUrl;
    }else{
        self.progressLabel.text = @"0%";
        self.progressView.progress = 0;
        self.stateLabel.text = @"未下载";
        videoUrl = [NSURL URLWithString:self.url];
    }
    self.nameLabel.text = self.url;
    [self setVideoUrl:videoUrl];
}


-(void)deleteVideo{
    if (self.isDown) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.key];
        [[NSFileManager defaultManager] removeItemAtPath:self.localUrl.path error:nil];
        self.stateLabel.text = @"未下载";
        self.progressView.progress = 0;
        self.isDown = NO;
    }
}

-(void)shareVideo{
    NSURL *URL;
    if (self.isDown) {
        URL = self.localUrl;
    }else{
        URL = [NSURL URLWithString:self.url];
    }
    NSArray *activityItems = @[URL];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed) {
            [JMTip showCenterWithText:@"分享成功"];
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
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

- (IBAction)saveToLocal:(id)sender {
    if (self.isDown) {
        [self.localUrl.path jm_saveVideoToAlbums];
    }else{
        [JMTip showCenterWithText:@"本地找不到文件"];
    }
}


#pragma mark - 获取视频第一帧
- (void)setVideoUrl:(NSURL *)url{
    UIImage *image = (UIImage *)[[HUserManager manager] getCacheObjectForKey:self.key];
    if (image) {
        self.photoView.image = image;
    }else{
        [self loadImageWithUrl:url forKey:self.key];
    }
}

-(void)loadImageWithUrl:(NSURL *)videoUrl forKey:(NSString *)key{
    NSOperationQueue *queue = [HUserManager manager].queue;
    [queue addOperationWithBlock:^{
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

#pragma mark --- 懒加载
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

-(NSURL *)localUrl{
    if (!_localUrl) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *url  = [path stringByAppendingPathComponent:self.key];
        _localUrl = [NSURL fileURLWithPath:url];
    }
    return _localUrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

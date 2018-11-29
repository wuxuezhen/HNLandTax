//
//  HomeTableViewCell.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/9/12.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "HUserManager.h"
@import AVKit;
@interface HomeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@end
@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)setVideo:(WZVideo *)video{
    _video = video;
    self.stateLabel.text = video.isDownload ? @"已下载" : @"未下载";
    self.nameLabel.text  = video.key;
 
    UIImage *image = (UIImage *)[[HUserManager manager] getCacheObjectForKey:video.key];
    if (image) {
        self.photoView.image = image;
    }
//    else{
//        [self loadImageWithUrl:video.playURL forKey:video.key];
//    }
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
>>>>>>> e8bc6063640af50dd33a2d703a7f72ae83fffc78
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

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
- (void)setPath:(NSString *)path{
    _path = path;
    NSString *string = path.lastPathComponent;
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:string];
    self.nameLabel.text = path.lastPathComponent;
    NSURL *videoUrl = nil;
    if (url) {
        self.stateLabel.text = @"已下载";
        videoUrl = [NSURL fileURLWithPath:url];
    }else{
        self.stateLabel.text = @"未下载";
        videoUrl = [NSURL URLWithString:path];
    }
    UIImage *image = (UIImage *)[[HUserManager manager] getCacheObjectForKey:string];
    if (image) {
        self.photoView.image = image;
    }else{
        [self loadImageWithUrl:videoUrl forKey:string];
    }
   
}

-(void)loadImageWithUrl:(NSURL *)videoUrl forKey:(NSString *)key{
    NSOperationQueue *queue = [HUserManager manager].queue;
    [queue addOperationWithBlock:^{
        UIImage *image = [self getVideoPreViewImage:videoUrl];
        [[HUserManager manager] cacheObject:image forKey:key];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.photoView.image = image;
        }];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

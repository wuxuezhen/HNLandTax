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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

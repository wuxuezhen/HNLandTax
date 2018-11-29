//
//  UIViewController+WZShare.m
//  HNLandTax
//
//  Created by wzz on 2018/11/27.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "UIViewController+WZShare.h"
#import <UShareUI/UShareUI.h>
@implementation UIViewController (WZShare)

#pragma mark - 分享网页 默认平台
- (void)wz_shareObjectWithShare:(WZShare *)share
                  clickPlatform:(void (^)(UMSocialPlatformType))clickPlatform
                        success:(void (^)(NSString * _Nullable))success
                        failure:(void (^)(NSString * _Nullable, NSError * _Nullable))failure{
    
    UMSocialMessageObject *messageObj = [self wz_socialMessageObjectWithShare:share];
    NSArray *platforms                = @[@(UMSocialPlatformType_WechatTimeLine)];
    [UMSocialUIManager setPreDefinePlatforms:platforms];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        clickPlatform ? clickPlatform(platformType) : nil;
        [self wz_shareWithPlatform:platformType messageObject:messageObj success:success failure:failure];
    }];
}

#pragma mark - 分享网页 需传入具体平台
-(void)wz_shareObjectWithShare:(WZShare *)share
             sharePlatformType:(UMSocialPlatformType)platformType
                       success:(void (^)(NSString * _Nullable))success
                       failure:(void (^)(NSString * _Nullable, NSError * _Nullable))failure{
    UMSocialMessageObject *messageObj = [self wz_socialMessageObjectWithShare:share];
    [self wz_shareWithPlatform:platformType messageObject:messageObj success:success failure:failure];
}


#pragma mark - 分享回调公共方法
-(void)wz_shareWithPlatform:(UMSocialPlatformType)platformType
              messageObject:(UMSocialMessageObject *)messageObject
                    success:(void (^)(NSString * _Nullable))success
                    failure:(void (^)(NSString * _Nullable, NSError * _Nullable))failure{
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:nil
                                           completion:^(id result, NSError *error) {
                                               if (!error) {
                                                   if (success) {
                                                       success(@"分享成功");
                                                   }
                                               }else{
                                                   NSString *message = [error.userInfo objectForKey:@"message"];
                                                   if (message && [message rangeOfString:@"cancel"].location != NSNotFound) {
                                                       message = @"取消分享";
                                                   }
                                                   message = message ? :@" 分享失败";
                                                   if (failure) {
                                                       failure(message, error);
                                                   }
                                               }
                                           }];
}


#pragma mark - 创建分享对象
-(UMSocialMessageObject *)wz_socialMessageObjectWithShare:(WZShare *)share{
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    if (share.isShareWeb) {
        messageObj.shareObject = [self wz_shareWebpageObjectWithShare:share];
    }else{
        messageObj.shareObject = [self wz_shareImageObjectWithShare:share];
    }
    return messageObj;
}

#pragma mark - 创建图片分享对象
-(UMShareImageObject *)wz_shareImageObjectWithShare:(WZShare *)share{
    UMShareImageObject *shareImageObject = [UMShareImageObject shareObjectWithTitle:share.title
                                                                              descr:share.desc
                                                                          thumImage:share.thumImage];
    [shareImageObject setShareImage:share.shareImage];
    return shareImageObject;
}

#pragma mark - 创建网页分享对象
-(UMShareWebpageObject *)wz_shareWebpageObjectWithShare:(WZShare *)share{
    UMShareWebpageObject *shareWebpageObject = [UMShareWebpageObject shareObjectWithTitle:share.title
                                                                                    descr:share.desc
                                                                                thumImage:share.thumImage];
    shareWebpageObject.webpageUrl = share.url;
    return shareWebpageObject;
}

#pragma mark - 创建音乐分享对象
-(UMShareMusicObject *)wz_shareMusicObjectWithShare:(WZShare *)share{
    UMShareMusicObject *shareMusicObject = [UMShareMusicObject shareObjectWithTitle:share.title
                                                                                    descr:share.desc
                                                                                thumImage:share.thumImage];
    shareMusicObject.musicUrl = share.url;//音乐网页的url地址
    shareMusicObject.musicLowBandUrl = share.url;//音乐lowband网页的url地址
    shareMusicObject.musicDataUrl = share.url;//音乐数据url地址
    shareMusicObject.musicLowBandDataUrl = share.url;//音乐lowband数据url地址
    return shareMusicObject;
}


#pragma mark - 创建视频分享对象
-(UMShareVideoObject *)wz_shareVideoObjectWithShare:(WZShare *)share{
    UMShareVideoObject *shareVideoObject = [UMShareVideoObject shareObjectWithTitle:share.title
                                                                              descr:share.desc
                                                                          thumImage:share.thumImage];
    shareVideoObject.videoUrl = share.url;//视频网页的url
    shareVideoObject.videoLowBandUrl = share.url;//视频lowband网页的url
    shareVideoObject.videoStreamUrl = share.url;//视频数据流url
    shareVideoObject.videoLowBandStreamUrl = share.url;//视频lowband数据流url
    return shareVideoObject;
}

#pragma mark - 创建文件分享对象
-(UMShareFileObject *)wz_shareFileObjectWithShare:(WZShare *)share{
    UMShareFileObject *shareFileObject = [[UMShareFileObject alloc]init];
    shareFileObject.fileExtension = nil;
    shareFileObject.fileData = nil;
    return shareFileObject;
}


@end

//
//  UIViewController+FITShare.m
//  FitBody
//
//  Created by caiyi on 2018/8/22.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "UIViewController+FITShare.h"
#import <UShareUI/UShareUI.h>

@implementation UIViewController (FITShare)

#pragma mark - 分享网页
/**
 普通分享网页 调用UM默认控件
 
 @param url url
 @param title 标题
 @param descr 描述
 @param success 分享成功
 @param failure 分享失败
 */
- (void)fit_shareWebWithUrl:(NSString *)url
                      title:(NSString *)title
                       desc:(NSString *)descr
                  thumImage:(UIImage *)thumImage
                    success:(void (^)(NSString *))success
                    failure:(void (^)(NSString *))failure{
    
    UMSocialMessageObject *messageObj = [self fit_getWebMessageObjWithUrl:url
                                                                    title:title
                                                                    descr:descr
                                                                thumImage:thumImage];
    
    [UMSocialUIManager setPreDefinePlatforms:[self fit_platformsDefault]];
    // UM分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self fit_shareWithPlatType:platformType messageObject:messageObj success:success failure:failure];
    }];
    
}


/**
 分享网页，根据平台进行分享
 
 @param url 链接
 @param title 标题
 @param descr 描述
 @param thumImage icon
 @param success 分享成功
 @param failure 分享失败
 */
-(void)fit_shareWebWithPlatformType:(UMSocialPlatformType)platformType
                                Url:(NSString *)url
                              title:(NSString *)title
                               desc:(NSString *)descr
                          thumImage:(UIImage *)thumImage
                            success:(void (^)(NSString *))success
                            failure:(void (^)(NSString *))failure{
    
    
    UMSocialMessageObject *messageObj = [self fit_getWebMessageObjWithUrl:url
                                                                    title:title
                                                                    descr:descr
                                                                thumImage:thumImage];
    
    [self fit_shareWithPlatType:platformType messageObject:messageObj success:success failure:failure];
    
}


#pragma mark - 分享图片
/**
 普通分享图片 调用UM默认控件
 
 @param shareImage 分享图片
 @param title 标题
 @param descr 描述
 @param success 分享成功
 @param failure 分享失败
 */

- (void)fit_shareWebWithShareImage:(id)shareImage
                             title:(NSString *)title
                              desc:(NSString *)descr
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure{
    
    UMSocialMessageObject *messageObj = [self fit_getImageMessageObjWithImage:shareImage
                                                                        title:title
                                                                        descr:descr];
    
    [UMSocialUIManager setPreDefinePlatforms:[self fit_platformsDefault]];
    // UM分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self fit_shareWithPlatType:platformType messageObject:messageObj success:success failure:failure];
    }];
    
}


/**
 分享图片，根据平台进行分享
 
 @param shareImage 分享图片
 @param title 标题
 @param descr 描述
 @param success 分享成功
 @param failure 分享失败
 */
-(void)fit_shareImageWithPlatformType:(UMSocialPlatformType)platformType
                           shareImage:(id)shareImage
                                title:(NSString *)title
                                 desc:(NSString *)descr
                              success:(void (^)(NSString *))success
                              failure:(void (^)(NSString *))failure{
    
    
    UMSocialMessageObject *messageObj = [self fit_getImageMessageObjWithImage:shareImage
                                                                        title:title
                                                                        descr:descr];
    [self fit_shareWithPlatType:platformType messageObject:messageObj success:success failure:failure];
    
}






#pragma mark - ******************************************  分割线  ********************************************

#pragma mark - fit share config

/**
 分享回调
 
 @param platType 平台
 @param messageObject 分享对象
 @param success 成功
 @param failure 失败
 */
-(void)fit_shareWithPlatType:(UMSocialPlatformType)platType
               messageObject:(UMSocialMessageObject *)messageObject
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure{
    
    [[UMSocialManager defaultManager] shareToPlatform:platType
                                        messageObject:messageObject
                                currentViewController:nil
                                           completion:^(id result, NSError *error) {
                                               if (!error) {
                                                   success ? success(@"分享成功") : nil;
                                               }else{
                                                   NSString *message = [error.userInfo objectForKey:@"message"];
                                                   if (message && [message rangeOfString:@"cancel"].location != NSNotFound) {
                                                       message = @"取消分享";
                                                   }
                                                   message = message ? :@" 分享失败";
                                                   failure ? failure(message) : nil;
                                               }
                                           }];
}


/**
 配置分享平台，默认
 
 @return 分享平台
 */
-(NSArray *)fit_platformsDefault{
    return @[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)];
}


/**
 获取网页分享对象
 
 @param url 链接
 @param title 标题
 @param descr 描述
 @param thumImage icon
 @return 分享对象
 */
-(UMSocialMessageObject *)fit_getWebMessageObjWithUrl:(NSString *)url
                                                title:(NSString *)title
                                                descr:(NSString *)descr
                                            thumImage:(id)thumImage{
    
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:title
                                                                        descr:descr
                                                                    thumImage:thumImage];
    webObj.webpageUrl = url;
    messageObj.shareObject = webObj;
    return messageObj;
}


/**
 获取图片分享对象
 
 @param image 分享的图片
 @param title 标题
 @param descr 描述
 @return 分享对象
 */
-(UMSocialMessageObject *)fit_getImageMessageObjWithImage:(id)image
                                                    title:(NSString *)title
                                                    descr:(NSString *)descr{
    
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareImage = [[UMShareImageObject alloc] init];
    
    shareImage.title = title;
    shareImage.descr = descr;
    shareImage.shareImage = image;
    messageObj.shareObject = shareImage;
    return messageObj;
}


@end

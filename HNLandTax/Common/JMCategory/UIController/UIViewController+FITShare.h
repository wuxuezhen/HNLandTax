//
//  UIViewController+FITShare.h
//  FitBody
//
//  Created by caiyi on 2018/8/22.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface UIViewController (FITShare)
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
                    failure:(void (^)(NSString *))failure;


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
                            failure:(void (^)(NSString *))failure;


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
                           failure:(void (^)(NSString *))failure;


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
                              failure:(void (^)(NSString *))failure;

@end


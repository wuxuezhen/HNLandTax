//
//  UIViewController+WZShare.h
//  HNLandTax
//
//  Created by wzz on 2018/11/27.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WZShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (WZShare)
/**
 分享网页  分享图片
 */
- (void)wz_shareObjectWithShare:(WZShare *)share
                  clickPlatform:(void (^_Nullable)(UMSocialPlatformType))clickPlatform
                        success:(void (^_Nullable)(NSString * _Nullable))success
                        failure:(void (^_Nullable)(NSString * _Nullable, NSError * _Nullable))failure;


- (void)wz_shareObjectWithShare:(WZShare *)share
              sharePlatformType:(UMSocialPlatformType)platformType
                        success:(void (^_Nullable)(NSString * _Nullable))success
                        failure:(void (^_Nullable)(NSString * _Nullable, NSError * _Nullable))failure;

@end

NS_ASSUME_NONNULL_END

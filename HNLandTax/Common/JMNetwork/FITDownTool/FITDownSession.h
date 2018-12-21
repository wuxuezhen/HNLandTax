//
//  FITDownSession.h
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FITDownLoadResponse.h"

typedef void(^DownloadBlock)(FITDownLoadResponse *response);
@protocol DownloadDelegate <NSObject>

-(void)wz_download:(FITDownLoadResponse *)response;

@end

@interface FITDownSession : NSObject

@property (nonatomic, assign, readonly) double progress;

@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, weak) id <DownloadDelegate> delegate;

/**
 ** 初始化 配置一个下载任务 支持离线断点下载
 
 @param downloadUrl 下载链接
 @param identifier 标识符
 @param downloadHandler 回调
 */
-(instancetype)initWithDownloadUrl:(NSString *) downloadUrl
                        identifier:(NSString *) identifier
                   downloadHandler:(DownloadBlock) downloadHandler;

/**
** session 配置一个下载任务 支持离线断点下载

 @param downloadUrl 下载链接
 @param identifier 标识符
 @param downloadHandler 回调
 */
- (void)downloadTaskWithDownloadUrl:(NSString *) downloadUrl
                         identifier:(NSString *) identifier
                    downloadHandler:(DownloadBlock) downloadHandler;


/**
 暂停下载
 */
- (void)fit_downloadPause;


/**
 开始/回复下载
 */
- (void)fit_downloadResume;

/**
 取消下载
 */
- (void)fit_downloadCancle;

/**
 重新下载
 */
- (void)fit_reDownloadResume;

@end

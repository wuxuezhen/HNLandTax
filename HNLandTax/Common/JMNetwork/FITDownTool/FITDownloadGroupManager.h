//
//  FITDownloadGroupManager.h
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/30.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FITDownLoadResponse.h"
@interface FITDownloadGroupManager : NSObject

typedef void (^downloadResponse)(FITDownLoadResponse *response);

@property (nonatomic, strong) NSOperationQueue *taskQueue;

+(instancetype)manager;

// 下载请求
- (void)addDownloadRequest:(NSString *)downloadUrl
                identifier:(NSString *)identifier
                targetSelf:(id)targetSelf
              showProgress:(BOOL)showProgress
      isDownloadBackground:(BOOL)isDownloadBackground
          downloadResponse:(downloadResponse)downloadResponse;


// 所有下载任务控制
- (void)pauseAllDownloadRequest;
- (void)cancleAllDownloadRequest;
- (void)resumeAllDownloadRequest;

// 单个下载任务控制
- (void)pauseDownload:(NSString *)identifier;
- (void)resumeDownload:(NSString *)identifier;
- (void)cancleDownload:(NSString *)identifier;


@end


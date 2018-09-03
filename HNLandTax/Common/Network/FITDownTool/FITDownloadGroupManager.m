//
//  FITDownloadGroupManager.m
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/30.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import "FITDownloadGroupManager.h"
#import "FITDownSession.h"
#define OperationCount  5

@interface FITDownloadGroupManager ()
@property (nonatomic, strong) NSMutableArray *downloadManagerArr;

@property (nonatomic, copy) downloadResponse response;

@end
@implementation FITDownloadGroupManager

- (instancetype)init {
    if (self = [super init]) {
        self.downloadManagerArr = [NSMutableArray array];
    }
    return self;
}


- (void)addDownloadRequest:(NSString *)downloadUrl
                identifier:(NSString *)identifier
                targetSelf:(id)targetSelf
              showProgress:(BOOL)showProgress
      isDownloadBackground:(BOOL)isDownloadBackground
          downloadResponse:(downloadResponse)downloadResponse {
    
    self.response = downloadResponse;
    
    [self.taskQueue addOperationWithBlock:^{
        __weak typeof(self) this = self;
        FITDownSession *downloadManager = [[FITDownSession alloc] init];
        [downloadManager downloadTaskWithDownloadUrl:downloadUrl
                                          identifier:identifier
                                     downloadHandler:^(FITDownLoadResponse *response) {
                                         
                                         if (response.downloadStatus == FITDownloadCancle ||
                                             response.downloadStatus == FITDownloadSuccuss ||
                                             response.downloadStatus == FITDownloadfailure) {
                                             this.response(response);
                                             [this removeDownloadTask:response.identifier];
                                         }else if(response.downloadStatus == FITDownloading){
                                             if (showProgress) {
                                                 this.response(response);
                                             }
                                         }else{
                                               this.response(response);
                                         }
                                         
                                     }];
      
        [self.downloadManagerArr addObject:downloadManager];
    }];
    
}
#pragma mark - 批量任务处理
- (void)pauseAllDownloadRequest {
    NSMutableArray * temp = nil;
    temp = self.downloadManagerArr;
    [self.downloadManagerArr enumerateObjectsUsingBlock:^(FITDownSession *manager, NSUInteger idx, BOOL *stop) {
        [manager fit_downloadPause];
    }];
}

- (void)cancleAllDownloadRequest {
    __weak typeof(self) this = self;
    [self.downloadManagerArr enumerateObjectsUsingBlock:^(FITDownSession *manager, NSUInteger idx, BOOL *stop) {
        [manager fit_downloadCancle];
        [this removeDownloadTask:manager.identifier];
    }];
}

- (void)resumeAllDownloadRequest {
    NSMutableArray * temp = nil;
    temp = self.downloadManagerArr;
    [self.downloadManagerArr enumerateObjectsUsingBlock:^(FITDownSession *manager, NSUInteger idx, BOOL *stop) {
        [manager fit_downloadResume];
    }];
}

#pragma mark - 单个任务，暂停、重启、取消
- (void)pauseDownload:(NSString *)identifier {
    [[self getDownloadManager:identifier] fit_downloadPause];
}

- (void)resumeDownload:(NSString *)identifier {
     [[self getDownloadManager:identifier] fit_downloadResume];
}

- (void)cancleDownload:(NSString *)identifier {
    [[self getDownloadManager:identifier] fit_downloadCancle];
    [self removeDownloadTask:identifier];
}


#pragma mark - 删除下载任务
- (void)removeDownloadTask:(NSString *)identifier {
    if (!self.downloadManagerArr && self.downloadManagerArr.count == 0) {
        return;
    }
    __weak typeof(self) this = self;
    [self.downloadManagerArr enumerateObjectsUsingBlock:^(FITDownSession *session, NSUInteger idx, BOOL *stop) {
        if ([session.identifier isEqualToString:identifier]) {
            [this.downloadManagerArr removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}

#pragma mark -  根据 identifier 获取下载任务
- (FITDownSession *)getDownloadManager:(NSString *)identifier {
    __block FITDownSession *sessionManager = nil;
    [self.downloadManagerArr enumerateObjectsUsingBlock:^(FITDownSession *session, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([identifier isEqualToString:session.identifier]) {
            sessionManager = session;
            *stop = YES;
        }
    }];
    return sessionManager;
}

#pragma mark - getter/setter
- (NSOperationQueue *)taskQueue {
    if (!_taskQueue) {
        _taskQueue = [[NSOperationQueue alloc] init];
        _taskQueue.maxConcurrentOperationCount = 5;
    }
    return _taskQueue;
}


@end

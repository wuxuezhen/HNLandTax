//
//  FITDownManager.m
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import "FITDownManager.h"
#import "AFNetworking.h"

static NSString *kCancel = @"cancelled";

@interface FITDownManager ()

@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
@property (nonatomic, strong) AFURLSessionManager *manager;

@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, copy)   NSString *fileName;

@property (nonatomic, copy)   DownloadBlock downloadHandler;

@property (nonatomic, strong) FITDownLoadResponse *response;
@property (nonatomic, assign) double lastProgress;

@end

@implementation FITDownManager

#pragma mark - config
/**
 ** 初始化 配置一个下载任务 支持离线断点下载
 
 @param downloadUrl 下载链接
 @param identifier 标识符
 @param downloadHandler 回调
 */
-(instancetype)initWithDownloadUrl:(NSString *)downloadUrl
                        identifier:(NSString *)identifier
                   downloadHandler:(DownloadBlock)downloadHandler{
    if (self = [super init]) {
        self.downloadUrl      = downloadUrl;
        self.downloadHandler  = downloadHandler;
        self.identifier       = identifier;
    }
    return self;
}

/**
 ** session 配置一个下载任务 支持离线断点下载
 
 @param downloadUrl 下载链接
 @param identifier 标识符
 @param downloadHandler 回调
 */
-(void)downloadTaskWithDownloadUrl:(NSString *)downloadUrl
                        identifier:(NSString *)identifier
                   downloadHandler:(DownloadBlock)downloadHandler{
    self.downloadUrl      = downloadUrl;
    self.downloadHandler  = downloadHandler;
    self.identifier       = identifier;
    
    [self fit_downloadResume];
    
}

#pragma mark - 开始，停止，取消，重新
/**
 * 开始下载，继续下载
 */
-(void)fit_downloadResume{
    // 获取已经下载的文件长度
    if (self.response.downloadStatus == FITDownloadSuccuss) {
        self.downloadHandler ? self.downloadHandler(self.response) : nil;
        return;
    }
    NSInteger currentLength = [self fileLengthForPath:[self getFilePath]];
    if (currentLength > 0) {
        self.currentLength = currentLength;
    }
    [self.downloadTask resume];
    
    [self updateRespose:FITDownloadResume
             identifier:self.identifier
            downloadUrl:self.downloadUrl
               progress:self.lastProgress
                fileUrl:nil];
}

/**
 重新下载
 */
- (void)fit_reDownloadResume{
    self.downloadTask = nil;
    self.currentLength = 0;
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self getFilePath]
                                               error:&error];
    
    [self.downloadTask resume];
    
    [self updateRespose:FITDownloadResume
             identifier:self.identifier
            downloadUrl:self.downloadUrl
               progress:self.lastProgress
                fileUrl:nil];
}

/**
 停止下载
 */
-(void)fit_downloadPause{
    [self.downloadTask suspend];
    self.downloadTask = nil;
    
    [self updateRespose:FITDownloadPause
             identifier:self.identifier
            downloadUrl:self.downloadUrl
               progress:self.lastProgress
                fileUrl:nil];
}


/**
 取消下载
 */
-(void)fit_downloadCancle{
    if (_downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    [self updateRespose:FITDownloadCancle
             identifier:self.identifier
            downloadUrl:nil
               progress:self.lastProgress
                fileUrl:nil];
    
}


#pragma mark - 任务下载回调事件

/**
 下载任务收到回复
 
 @param response
 */
-(void)taskDidReceiveResponse:(NSURLResponse *)response{
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength + self.currentLength;
    // 沙盒文件路径
    NSString *path = [self getFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    self.response.downloadSaveFileUrl = [NSURL URLWithString:path];
    
}

/**
 下载任务接收数据
 
 @param data
 */
-(void)taskDidReceiveData:(NSData *)data{
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    double progress = 0.0;
    if (self.fileLength != 0) {
        progress =  1.0 * self.currentLength / self.fileLength;
    }
    self.lastProgress = progress;
    
    [self updateRespose:FITDownloading
             identifier:self.identifier
            downloadUrl:nil
               progress:self.lastProgress
                fileUrl:nil];
    
}

/**
 下载任务完成
 */
-(void)taskDownCompletion:(NSError *)error{
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
    
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    if ([[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:kCancel]) {
        [self updateRespose:FITDownloadCancle
                 identifier:self.identifier
                downloadUrl:nil
                   progress:self.lastProgress
                    fileUrl:nil];
    }else{
        [self updateRespose:FITDownloadSuccuss
                 identifier:self.identifier
                downloadUrl:nil
                   progress:1.0
                    fileUrl:nil];
    }
}


/**
 更新response
 
 */
- (void)updateRespose:(FITDownloadStatus)status
           identifier:(NSString *)identifier
          downloadUrl:(NSString *)downloadUrl
             progress:(double)progress
              fileUrl:(NSURL *)fileUrl{
    
    self.response.downloadStatus = status;
    self.response.identifier = identifier;
    if (progress > 0) {
        self.response.progress = progress;
    }
    if (downloadUrl) {
        self.response.downloadUrl = downloadUrl;
    }
    if (fileUrl) {
        self.response.downloadSaveFileUrl = fileUrl;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.downloadHandler(self.response);
    }];
    
};

#pragma mark - 下载配置 私有方法
-(void)setDownloadUrl:(NSString *)downloadUrl{
    _downloadUrl = downloadUrl;
    self.fileName = [[NSURL URLWithString:downloadUrl] lastPathComponent];
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];// default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path
                                                               error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

/**
 存储路径
 
 @return path
 */
-(NSString *)getFilePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (self.identifier) {
        return [path stringByAppendingPathComponent:self.identifier];
    }else{
        return [path stringByAppendingPathComponent:self.fileName];
    }
}


#pragma mark - 懒加载
/**
 * downloadTask的懒加载
 */
- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:self.downloadUrl]];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (response.expectedContentLength == 0) {
                [weakSelf taskDownCompletion:nil];
            }else{
                [weakSelf taskDownCompletion:error];
            }
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            
            [weakSelf taskDidReceiveResponse:response];
            
            return NSURLSessionResponseAllow;
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            
            [weakSelf taskDidReceiveData:data];
            
        }];
    }
    
    return _downloadTask;
}


/**
 * manager的懒加载
 */
- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[self getSessionConfiguration:self.identifier]];
    }
    return _manager;
}

/**
 懒加载初始化 response
 
 @return response
 */
-(FITDownLoadResponse *)response{
    if (!_response) {
        _response = [[FITDownLoadResponse alloc]init];
    }
    return _response;
}

/**
 Configuration
 
 @param identifier id
 @return config
 */
-(NSURLSessionConfiguration *)getSessionConfiguration:(NSString *)identifier{
    NSString *string = [NSString stringWithFormat:@"background-NSURLSession-%@",identifier];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:string];
    config.HTTPMaximumConnectionsPerHost = 5;
    return config;
}


@end

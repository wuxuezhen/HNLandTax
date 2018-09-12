//
//  FITDownSession.m
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import "FITDownSession.h"


@interface FITDownSession ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, copy) NSString *fileName;


@property (nonatomic, copy) DownloadBlock downloadHandler;
@property (nonatomic, strong) FITDownLoadResponse *response;

@property (nonatomic, assign) double lastProgress;

@end

@implementation FITDownSession

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
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self getFilePath]
                                               error:&error];
    
    [self updateRespose:FITDownloadPause
             identifier:self.identifier
            downloadUrl:self.downloadUrl
               progress:self.lastProgress
                fileUrl:nil];
    
}

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


#pragma mark - 任务下载代理事件

/**
 下载任务收到回复
 
 @param response
 */
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength + self.currentLength;
    // 沙盒文件路径
    NSString *path = [self getFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    self.response.downloadSaveFileUrl = [NSURL fileURLWithPath:path];
    
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data{
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
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
    
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    if (error) {
        [self updateRespose:FITDownloadfailure
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
        self.downloadHandler ? self.downloadHandler(self.response) : nil;
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
 
 @return
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
        _downloadTask = [self.session dataTaskWithRequest:request];
    }
    
    return _downloadTask;
}


/**
 * manager的懒加载
 */
- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[self getSessionConfiguration:self.identifier]
                                                 delegate:self
                                            delegateQueue:nil];
        _session.sessionDescription = @"FITDownloadUrlSession";
    }
    return _session;
}

/**
 Configuration
 
 @param identifier id
 @return
 */
-(NSURLSessionConfiguration *)getSessionConfiguration:(NSString *)identifier{
    NSString *string = [NSString stringWithFormat:@"background-NSURLSession-%@",identifier];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:string];
    config.HTTPMaximumConnectionsPerHost = 5;
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

-(FITDownLoadResponse *)response{
    if (!_response) {
        _response = [[FITDownLoadResponse alloc]init];
    }
    return _response;
}
@end

//
//  DownloadTool.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/8/31.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "DownloadTool.h"
@interface DownloadTool()

/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) double progress;
@property (nonatomic, copy) successBlock successBlock;
@property (nonatomic, copy) progressBlock progressBlock;
@end
@implementation DownloadTool
/**
 请求单例
 
 @return 单例对象
 */
+ (AFURLSessionManager *)shareManager {
    static AFURLSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"background-download"];
        configuration.HTTPMaximumConnectionsPerHost = 5;
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    
    return manager;
}

-(void)resumeDownload{
    [self.downloadTask resume];
}

-(void)downLoadWithDownloadUrl:(NSString *)downloadUrl
                       success:(successBlock)success
                      progress:(progressBlock)progress{
    
    self.downloadUrl = downloadUrl;
    self.successBlock = success;
    self.progressBlock = progress;
    self.currentLength = [self fileLengthForPath:[self getPath]];
    [self resumeDownload];
}
- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        // 创建下载URL
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [[DownloadTool shareManager] dataTaskWithRequest:request
                                                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           
                                                           // 清空长度
                                                           weakSelf.currentLength = 0;
                                                           weakSelf.fileLength = 0;
                                                           
                                                           // 关闭fileHandle
                                                           [weakSelf.fileHandle closeFile];
                                                           weakSelf.fileHandle = nil;
                                                           weakSelf.successBlock([weakSelf getPath]);
                                                           
                                                       }];
        
        [[DownloadTool shareManager] setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            
            weakSelf.fileLength = response.expectedContentLength + self.currentLength;
            
            NSString *path = [weakSelf getPath];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
            }
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
            
            return NSURLSessionResponseAllow;
        }];
        
        [[DownloadTool shareManager] setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            NSLog(@"setDataTaskDidReceiveDataBlock");
            
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            
            double progress = 1.0 * weakSelf.currentLength / weakSelf.fileLength;
            [mainQueue addOperationWithBlock:^{
                self.progressBlock(progress);
            }];
        }];
    }
    return _downloadTask;
}

-(NSString *)getPath{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.fileName];
    
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

-(void)setDownloadUrl:(NSString *)downloadUrl{
    _downloadUrl = downloadUrl;
    self.fileName = downloadUrl.lastPathComponent;
}
@end

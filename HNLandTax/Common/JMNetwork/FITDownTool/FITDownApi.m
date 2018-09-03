//
//  FITDownApi.m
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import "FITDownApi.h"
#import "AFNetworking.h"

@implementation FITDownApi

/**
 AF单例
 
 @return 单例对象
 */
+ (AFURLSessionManager *)downAPI {
    static AFURLSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    return manager;
}


+(NSURLSessionDownloadTask *)downWithPath:(NSString *)path downProgress:(progressHandler)downProgress completion:(completionHandler)completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]
                                                           cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                                       timeoutInterval:30];
    
    NSURLSessionDownloadTask *downloadTask = [[self downAPI] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        double progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            downProgress(progress);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [self getImagePath:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:completion];
    
    [downloadTask resume];
    return downloadTask;
}

#pragma mark - ************************************* 分割线 *****************************************

/**
 session单例
 
 @return 单例对象
 */
+ (NSURLSession *)downSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sharedSession];
    });
    
    return session;
}

+(NSURLSessionDownloadTask *)downSessionWithPath:(NSString *)path completion:(completionHandler)completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]
                                                           cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                                       timeoutInterval:30];
    NSURLSessionDownloadTask *downloadTask = [[self downSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSString *path = [self getImagePath:response.suggestedFilename];
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:path error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response,[NSURL fileURLWithPath:path],error);
        });
        
    }];
    
    [downloadTask resume];
    return downloadTask;
    
}


/**
 文件本地存储路径
 
 @param suggestedFilename
 @return
 */
+ (NSString *)getImagePath:(NSString *)suggestedFilename{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"/image-%@%@",[self currentTimeInterval],suggestedFilename];
    return [cachesPath stringByAppendingPathComponent:fileName];
}

+(NSString *)currentTimeInterval{
    return @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
}


@end

//
//  FITDownApi.h
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 pshao. All rights reserved.
//
/**
 小文件下载，图片，word文档
 **/

#import <Foundation/Foundation.h>

typedef void (^completionHandler)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);
typedef void (^progressHandler)(double progress);

@interface FITDownApi : NSObject


//af 不支持断点下载
+ (NSURLSessionDownloadTask *_Nonnull)downWithPath:(NSString * _Nonnull)path
                                      downProgress:(progressHandler)downProgress
                                        completion:(completionHandler)completion;

//session 不支持断点下载
+ (NSURLSessionDownloadTask *_Nonnull)downSessionWithPath:(NSString * _Nonnull)path
                                               completion:(completionHandler)completion;


@end

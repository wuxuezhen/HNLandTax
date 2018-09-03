//
//  FITDownLoadResponse.h
//  AFNetworkingTest
//
//  Created by caiyi on 2018/8/30.
//  Copyright © 2018年 pshao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM (NSInteger, FITDownloadStatus) {
    FITDownloadNormal,
    FITDownloadSuccuss, // 下载成功
    FITDownloadfailure, // 下载失败
    FITDownloading, // 下载中
    FITDownloadResume, // 重启
    FITDownloadCancle, // 取消
    FITDownloadPause // 暂停
};

@interface FITDownLoadResponse : NSObject

@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *downloadResult;
@property (nonatomic, strong) NSURL *downloadSaveFileUrl;
@property (nonatomic, copy)   NSString * locaUrl;

@property (nonatomic, assign) FITDownloadStatus downloadStatus;
@property (nonatomic, assign) double progress;

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) id targert;

@end

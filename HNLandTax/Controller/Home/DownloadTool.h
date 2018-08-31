//
//  DownloadTool.h
//  HNLandTax
//
//  Created by 吴振振 on 2018/8/31.
//  Copyright © 2018年 WYW. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef void(^successBlock)(NSString *fliePath);
typedef void(^progressBlock)(double progress);

@interface DownloadTool : NSObject
@property (nonatomic, copy) NSString *downloadUrl;

-(void)downLoadWithDownloadUrl:(NSString *)downloadUrl
                       success:(successBlock)success
                      progress:(progressBlock)progress;
@end

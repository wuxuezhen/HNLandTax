//
//  WZVideo.h
//  HNLandTax
//
//  Created by wzz on 2018/11/22.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZVideo : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) NSURL *playURL;

-(void)wz_removeObjectForKey;
@end

NS_ASSUME_NONNULL_END

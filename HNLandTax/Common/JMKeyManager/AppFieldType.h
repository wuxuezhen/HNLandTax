//
//  AppFieldType.h
//  TuoDian
//
//  Created by wxz on 2017/7/25.
//  Copyright © 2017年 wxz. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *LDMeta    = @"meta";
static NSString *LDMessage = @"message";
static NSString *LDStatus  = @"status";
static NSString *LDData    = @"data";

static NSString *LDPage    = @"page";
static NSString *LDPageSize = @"page_size";
static NSString *LDPageCount = @"page_count";
static NSString *LDTotalCount = @"total_count";

static NSString *LDQuitEnterLoginface = @"quitEnterLoginface";
static NSString *LDNot_read_message_number = @"not_read_message_number";

static NSString *LDPhotoSaveAuthorityKey = @"photoSaveAuthorityKey";
static NSString *LDVedioSaveAuthorityKey = @"vedioSaveAuthorityKey";
static NSString *JMSportSignTipKey = @"kSportSignTipKey";
static NSString *JMLoginNewUserRedbag = @"kLoginNewUserRedbag";

static NSString *whetherOpenLocation = @"打开定位服务来允许店驰确定您的位置";
static NSString *openLocationMessage = @"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)";
static NSString *LDIPhoneMap         = @"苹果自带地图";

@interface AppFieldType : NSObject

@end

//
//  BDKeyManager.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *JMSystemVersion   = @"CFBundleShortVersionString";
static NSString *JMSystemBuilt     = @"CFBundleVersion";
static NSString *JMSystemAppName   = @"CFBundleDisplayName";
static NSString *JMDeviceVersion   = @"System-Version";



static NSString *AppStoreURL       = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1175471973";
static NSString *AppStoreAppraiseURL = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1175471973&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";

@interface BDKeyManager : NSObject

@end

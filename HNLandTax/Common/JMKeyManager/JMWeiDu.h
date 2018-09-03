//
//  JMWeiDu.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#ifndef JMWeiDu_h
#define JMWeiDu_h

#import "JMUI.h"
#import "JMTip.h"
#import "JMTool.h"
#import "UIColor+JMColor.h"
#import "JMDateFormat.h"
#import "PushType.h"
#import "AppFieldType.h"

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "NSString+ImageURL.h"

#import "UIView+FITHud.h"
#import "UIViewController+Alert.h"

#import "UITableViewCell+Nib.h"
#import "UICollectionViewCell+Nib.h"

#import "UITableView+JMRefresh.h"
#import "UICollectionView+JMRefresh.h"


#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define SCALE_W(wid) wid * SCREEN_W/375

#define WeakSelf(weakSelf)  __weak __typeof(self) weakSelf = self;

#ifdef BETA

#define LOCAL_LOGIN_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/loginInfoBeta"]
#define LOCAL_USETINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/userInformationBeta"]
#define LOCAL_SIGNINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/signInfoBeta"]
#define LOCAL_ALERTINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/alertInfoBeta"]

#else

#define LOCAL_LOGIN_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/loginInfo"]
#define LOCAL_USETINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/userInformation"]
#define LOCAL_SIGNINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/signInfo"]
#define LOCAL_ALERTINFO_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/alertInfo"]

#endif



#endif /* JMWeiDu_h */

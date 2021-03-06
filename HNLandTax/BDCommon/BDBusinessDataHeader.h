//
//  BDBusinessDataHeader.h
//  BusinessDataPlatform
//
//  Created by 吴振振 on 2019/1/9.
//  Copyright © 2019 donghui lv. All rights reserved.
//

#ifndef BDBusinessDataHeader_h
#define BDBusinessDataHeader_h

#import "BDUI.h"
#import "BDTip.h"
#import "BDTool.h"
#import "UIColor+BDColor.h"
#import "BDDateFormat.h"

#import "UIView+LoadingHud.h"

#import "UITableViewCell+Nib.h"
#import "UICollectionViewCell+Nib.h"

#import "UITableView+BDRefresh.h"
#import "UICollectionView+BDRefresh.h"

#import "UIResponder+ReverseEvent.h"
#import "UIView+Event.h"

#import "BDSafe.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define SCALE_W(wid) wid * SCREEN_W/375

#define kIsString(str) ([str isKindOfClass:[NSNull class]]||str==nil) ? @"" :([str isKindOfClass:[NSString class]] ? str:[NSString stringWithFormat:@"%@",str])

#define WeakSelf(weakSelf)  __weak __typeof(self) weakSelf = self;




#endif /* BDBusinessDataHeader_h */

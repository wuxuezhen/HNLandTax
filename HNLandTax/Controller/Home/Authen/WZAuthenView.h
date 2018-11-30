//
//  WZAuthenView.h
//  HNLandTax
//
//  Created by wzz on 2018/11/30.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZAuthenView : UIView
@property (nonatomic, copy) void (^touchAuthBlock)(void);
@end

NS_ASSUME_NONNULL_END

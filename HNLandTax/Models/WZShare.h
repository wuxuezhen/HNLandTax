//
//  WZShare.h
//  HNLandTax
//
//  Created by wzz on 2018/11/27.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZShare : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) id shareImage;

@property (nonatomic, strong) id thumImage;

@property (nonatomic, assign) BOOL isShareWeb;
@end

NS_ASSUME_NONNULL_END

//
//  WZLocalAuthentication.h
//  HNLandTax
//
//  Created by 吴振振 on 2018/11/29.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZLocalAuthentication : NSObject
-(void)wz_evaluatePolicy:(void(^)(BOOL, NSString * _Nullable, NSError * _Nullable))replyBlock;
@end


NS_ASSUME_NONNULL_END

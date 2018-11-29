//
//  WZLocalAuthentication.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/11/29.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "WZLocalAuthentication.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface WZLocalAuthentication ()
@property (nonatomic, strong) LAContext *context;
@end

@implementation WZLocalAuthentication

-(void)wz_evaluatePolicy:(void (^)(BOOL, NSString * _Nullable, NSError * _Nullable))replyBlock{
    
    if ([self wz_canEvaluatePolicy]) {
        NSString *localizedReasonKey = @"通过Home键验证已有手机指纹";
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                     localizedReason:localizedReasonKey
                               reply:^(BOOL success, NSError * _Nullable error) {
                                   NSString *message = nil;
                                   if (success) {
                                       message = @"TouchID 验证成功";
                                   }else if(error){
                                       
                                       switch (error.code) {
                                           case LAErrorAuthenticationFailed:
                                               message = @"TouchID 验证失败";
                                               break;
                                               
                                           case LAErrorUserCancel:
                                               message = @"TouchID 被用户手动取消";
                                               break;
                                               
                                           case LAErrorUserFallback:
                                               message = @"用户不使用TouchID,选择手动输入密码";
                                               break;
                                               
                                           case LAErrorSystemCancel:
                                               message = @"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)";
                                               break;
                                               
                                           case LAErrorPasscodeNotSet:
                                               message = @"TouchID 无法启动,因为用户没有设置密码";
                                               break;
                                               
                                           case LAErrorTouchIDNotEnrolled:
                                               message = @"TouchID 无法启动,因为用户没有设置TouchID";
                                               break;
                                               
                                           case LAErrorTouchIDNotAvailable:
                                               message = @"TouchID 无效";
                                               break;
                                               
                                           case LAErrorTouchIDLockout:
                                               message = @"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)";
                                               break;
                                               
                                           case LAErrorAppCancel:
                                               message = @"当前软件被挂起并取消了授权 (如App进入了后台等)";
                                               break;
                                               
                                           case LAErrorInvalidContext:
                                               message = @"当前软件被挂起并取消了授权 (LAContext对象无效)";
                                               break;
                                               
                                           default:
                                               break;
                                       }
                                   }
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       replyBlock ? replyBlock(success, message, error) : nil;;
                                   });
                               }];
        
    }else{
        NSLog(@"当前设备不支持TouchID");
    }
}


-(BOOL)wz_canEvaluatePolicy{
    //首先判断版本
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        return NO;
    }else{
        NSError *error = nil;
        return [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    }
}

-(LAContext *)context{
    if (!_context) {
        _context = [[LAContext alloc] init];
        _context.localizedFallbackTitle = @"输入密码";
        //      _context.localizedCancelTitle = @"";
    }
    return _context;
}
@end

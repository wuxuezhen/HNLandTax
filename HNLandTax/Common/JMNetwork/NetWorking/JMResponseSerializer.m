//
//  JMResponseSerializer.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMResponseSerializer.h"
#import "APPConstants.h"

@implementation JMResponseSerializer

- (instancetype)init {
    if (self = [super init]) {
//        self.removesKeysWithNullValues = YES;
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    }
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    id result = [super responseObjectForResponse:response data:data error:error];
    if (result) {
        if ([result isKindOfClass:NSDictionary.class]) {
            if ([result[@"code"] integerValue] != 100000) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                NSString *errorDescription = result[@"message"]?:[self errorMessage:[result[@"code"] integerValue]];
                userInfo[JMMETAERRMSGKEY] = errorDescription;
                userInfo[JMMETAERRCODEKEY] = result[@"code"];
                userInfo[JMMETAHTTPSTATUSKEY] = result[@"status"]?:@"";
                *error = [NSError errorWithDomain:JMMETAERRDOMIN
                                             code:[result[@"code"] integerValue]
                                         userInfo:userInfo];
            }
        }
    }
    return result;
}

-(NSString *)errorMessage:(NSInteger)code{
    NSString *message = nil;
    switch (code) {
        case 1:
            message = @"请求失败";
            break;
        case 100003:
            message = @"用户名或密码错误";
            break;
        case 100004:
            message = @"请核对输入的验证码与手机是否一致";;
            break;
        case 100005:
            message = @"账户不存在";
            break;
        case 100016:
            message = @"手机号未注册";
            break;
        case 100006:
            message = @"手机号已注册";
            break;
        case 100012:
            message = @"设备不存在";
            break;
        case 100007:
            message = @"请结束当前运动再开始新运动";
            break;
        case 100008:
            message = @"设备正在使用";
            break;
        case 100009:
            message = @"健身设备绑定失败";
            break;
        case 100011:
            message = @"操作频繁，请60秒后重试";
            break;
        case 100015:
            message = @"您的密码可能已经泄露，请重新设置";
            break;
        case 100020:
            message = @"该手机号已被其他用户绑定";
            break;
        case 100030:
           return @"用户昵称重复";
        case 100040:
            return @"话题已被删除";
        default:
            
            break;
    }
    return message;
}
@end



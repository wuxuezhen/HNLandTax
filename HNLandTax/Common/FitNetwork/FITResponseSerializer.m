//
//  FITResponseSerializer.m
//  FitBody
//
//  Created by caiyi on 2018/8/21.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "FITResponseSerializer.h"
#import "FITConstants.h"

@implementation FITResponseSerializer

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
    id result = [super responseObjectForResponse:response data:data error:error];
    
    if (result && responses.statusCode != 200) {
        if ([result isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            NSString *errorMsg = [self errorMessageWithBusiness:[result[@"code"] integerValue]];
            NSString *errorDescription = result[@"msg"] ? : errorMsg;
            userInfo[FITMETAERRMSGKEY] = errorDescription;
            userInfo[FITMETAERRCODEKEY] = result[@"code"];
            userInfo[FITMETARESPONSECODEKEY] = @(responses.statusCode);
            *error = [NSError errorWithDomain:FITMETAERRDOMIN
                                         code:responses.statusCode
                                     userInfo:userInfo];
        }
    }
    return result;
}


-(NSString *)errorMessageWithBusiness:(NSInteger)code{
    NSString *message = nil;
    switch (code) {
        case 2001:
            message = @"token失效，刷新token";
            break;
        case 2002:
            message = @"token失效，请重新登录";;
            break;
        case 2006:
            message = @"昵称已被注册";
            break;
        case 2022:
            message = @"昵称不合法";
            break;
      
        default:
            
            break;
    }
    return message;
}

-(NSString *)errorMessageWithRequest:(NSInteger)code{
    NSString *message = nil;
    switch (code) {
        case 400:
            message = @"请求失败";
            break;
        case 500:
            message = @"请求失败";
            break;
        case 403:
            message = @"非法的请求";
            break;
        case 498:
            message = @"token失效";
            break;
        default:
            
            break;
    }
    return message;
}
@end

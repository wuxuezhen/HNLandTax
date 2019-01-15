//
//  BDResponseSerializer.m
//
//  Created by caiyi on 2018/8/21.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "BDResponseSerializer.h"
#import "BDConstants.h"

@implementation BDResponseSerializer

- (instancetype)init {
    if (self = [super init]) {
        NSMutableSet *acceptSet = [self.acceptableContentTypes mutableCopy];
        [acceptSet addObject:@"text/plain"];
        [acceptSet addObject:@"text/javascript"];
        [acceptSet addObject:@"text/html"];
        [acceptSet addObject:@"text/css"];
        [acceptSet addObject:@"text/xml"];
        [acceptSet addObject:@"text/json"];
        [acceptSet addObject:@"text/html;charset=utf-8"];
        [acceptSet addObject:@"application/json"];
        [acceptSet addObject:@"application/javascript"];
        [acceptSet addObject:@"application/x-javascript"];
        [acceptSet addObject:@"application/x-gzip"];
        [acceptSet addObject:@"image/*"];
        self.acceptableContentTypes = [acceptSet copy];
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
//    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
    id result = [super responseObjectForResponse:response data:data error:error];
    BOOL success     = [result[BDSuccess] boolValue];
    NSInteger code   = [result[BDCode] integerValue];
//    NSInteger status = [result[BDStatus] integerValue];
    
    if (result && !success) {
        if ([result isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:result];
            NSString *errorMsg = [self errorMessageWithRequest:code];
            NSString *errorDescription   = result[BDMessage] ? : errorMsg;
            userInfo[BDMETAERRORMSGKEY]  = errorDescription;
            userInfo[BDMETAERRORCODEKEY] = @(code);
//            userInfo[BDMETARESPONSECODEKEY] = @(responses.statusCode);
            *error = [NSError errorWithDomain:BDMETAERRORDOMIN
                                         code:code
                                     userInfo:userInfo];
        }
    }
    return result[BDResult];
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

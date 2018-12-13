//
//  FITNetAPI.m
//
//  Created by caiyi on 2018/8/28.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "FITNetAPI.h"

@implementation FITNetAPI

#pragma mark - 需要传入请求方式请求方式
+ (NSURLSessionDataTask *)FITRequst:(FITNetRequst *)fitRequst success:(SuccessHandler)success failure:(FailureHandler)failure{
    
    switch (fitRequst.parseMethod) {
        case FITParseMethodObject:
            return [FITAPI requestWithMethod:fitRequst.requestMethod
                                        path:fitRequst.path
                                      params:fitRequst.parameters
                             parseIntoAClass:fitRequst.responseModel
                                     success:success
                                     failure:failure];
            break;
            
        case FITParseMethodList:
            return [FITAPI requestWithMethod:fitRequst.requestMethod
                                        path:fitRequst.path
                                      params:fitRequst.parameters
                       parseIntoArrayOfClass:fitRequst.responseModel
                                     success:success
                                     failure:failure];
            break;
            
        default:
            return [self requestWithFITRequst:fitRequst
                                      success:success
                                      failure:failure];
            break;
    }
}


+ (NSURLSessionDataTask *)requestWithFITRequst:(FITNetRequst *)fitRequst
                                       success:(SuccessHandler)success
                                       failure:(FailureHandler)failure {
    
    switch (fitRequst.requestMethod) {
        case FITAPIMethodGet:
            return [FITAPI GET:fitRequst.path
                        params:fitRequst.parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(responseObject);
                       } failure:failure];
            break;
        case FITAPIMethodPost:
            return [FITAPI GET:fitRequst.path
                        params:fitRequst.parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(responseObject);
                       } failure:failure];
            break;
        case FITAPIMethodPut:
            return [FITAPI GET:fitRequst.path
                        params:fitRequst.parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(responseObject);
                       } failure:failure];
            break;
        case FITAPIMethodDelete:
            return [FITAPI GET:fitRequst.path
                        params:fitRequst.parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(responseObject);
                       } failure:failure];
        default:
            break;
    }
}


@end

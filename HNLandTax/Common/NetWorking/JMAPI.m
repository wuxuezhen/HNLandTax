//
//  JMAPI.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMAPI.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import "APPConstants.h"
#import "JMKeyManager.h"
#import "JMResponseSerializer.h"

@implementation JMAPI

+ (AFHTTPSessionManager *)sharedAPI {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [JMResponseSerializer new];
        manager.operationQueue.maxConcurrentOperationCount = 20;
        manager.completionQueue = dispatch_queue_create("com.JM.api", DISPATCH_QUEUE_CONCURRENT);
        manager.requestSerializer.timeoutInterval = 20;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    });
    if ([self jm_token]) {
        [manager.requestSerializer setValue:[self jm_token]
                         forHTTPHeaderField:@"Authorization"];
    }else{
        [manager.requestSerializer setValue:@""
                         forHTTPHeaderField:@"Authorization"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    return manager;
}
+(NSString *)jm_token{
//    return [JMLoginManager jm_getLoginToken];
    return nil;
}
+(NSString *)appversion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:JMSystemVersion];
}


#pragma mark - GET、POST、PUT、DELETE 四请求方式
+ (NSURLSessionDataTask *)GET:(NSString *)path params:(NSDictionary *)params success:(void (^ _Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    return [[self sharedAPI] GET:path parameters:params progress:nil success:success
                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                             [self executeFailure:failure withError:error];
                         }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)path params:(NSDictionary *)params success:(void (^ _Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    return [[self sharedAPI] POST:path parameters:params progress:nil success:success
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [self executeFailure:failure withError:error];
                          }];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)path params:(NSDictionary *)params success:(void (^ _Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    return [[self sharedAPI] PUT:path parameters:params success:success
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [self executeFailure:failure withError:error];
                         }];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)path params:(NSDictionary *)params success:(void (^ _Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    return [[self sharedAPI] DELETE:path parameters:params success:success
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [self executeFailure:failure withError:error];
                            }];
}


#pragma mark - 根据请求方式调用请求接口 （不转数据模型）
+ (NSURLSessionDataTask *)requestWithMethod:(JMAPIMethod)method path:(NSString *)path params:(NSDictionary *)params success:(void (^ _Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    switch (method) {
        case JMAPIMethodGet:
            return [self GET:path params:params success:success failure:failure];
            break;
        case JMAPIMethodPost:
            return [self POST:path params:params success:success failure:failure];
            break;
        case JMAPIMethodPut:
            return [self PUT:path params:params success:success failure:failure];
            break;
        case JMAPIMethodDelete:
            return [self DELETE:path params:params success:success failure:failure];
        default:
            break;
    }
}



#pragma mark - 根据请求方式调用请求接口 （转数据模型）

/**
 数组不带key请求

 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 数据模型
 @param success 成功回调
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *)requestWithMethod:(JMAPIMethod)method
                                       path:(NSString *)path
                                     params:(NSDictionary *)params
                      parseIntoArrayOfClass:(Class)klass
                                    success:(void (^ _Nullable)(NSArray * _Nullable))success
                                    failure:(void (^ _Nullable)(NSError * _Nonnull))failure{
    return [self requestWithMethod:method
                              path:path
                            params:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = (NSDictionary *) responseObject;
                               if ([response[@"obj"] isKindOfClass:NSArray.class]) {
                                   NSArray *results = [self parseIntoArrayOfClass:klass fromArray:responseObject[@"obj"]];
                                   [self exectuteSuccess:success withResults:results];
                               } else {
                                   [self exectuteSuccess:success withResults:@[]];
                               }
                           }
                           failure:^(NSError *_Nonnull error) {
                               [self executeFailure:failure withError:error];
                           }];
}



/**
 数组带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 数据模型
 @param key 解析字段名称
 @param success 成功回调 数组
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *)requestWithMethod:(JMAPIMethod)method
                                       path:(NSString *)path
                                     params:(NSDictionary *)params
                      parseIntoArrayOfClass:(Class)klass
                                    withKey:(NSString *)key
                                    success:(void (^ _Nullable)(NSArray * _Nullable))success
                                    failure:(void (^ _Nullable)(NSError * _Nonnull))failure{
    return [self requestWithMethod:method
                              path:path
                            params:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = (NSDictionary *) responseObject;
                               if ([response[@"obj"] isKindOfClass:NSDictionary.class]) {
                                   NSDictionary *data = response[@"obj"];
                                   
                                   if (key && [[data objectForKey:key] isKindOfClass:NSArray.class]) {
                                       NSArray *results = [self parseIntoArrayOfClass:klass fromArray:[data objectForKey:key]];
                                       [self exectuteSuccess:success withResults:results];
                                   } else {
                                       [self exectuteSuccess:success withResults:@[]];
                                   }
                                   
                               } else {
                                   [self exectuteSuccess:success withResults:@[]];
                               }
                           }
                           failure:^(NSError *_Nonnull error) {
                               [self executeFailure:failure withError:error];
                           }];
}



/**
 对象不带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 数据模型
 @param success 成功回调 数组
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *)requestWithMethod:(JMAPIMethod)method
                                       path:(NSString *)path
                                     params:(NSDictionary *)params
                            parseIntoAClass:(Class)klass
                                    success:(void (^ _Nullable)(id))success
                                    failure:(void (^ _Nullable)(NSError *_Nonnull error))failure {
    return [self requestWithMethod:method path:path params:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = (NSDictionary *) responseObject;
                               if ([response[@"obj"] isKindOfClass:NSDictionary.class]) {
                                   NSDictionary *data = response[@"obj"];
                                   
                                   id result = [self parseIntoAClass:klass fromDict:data];
                                   jm_dispatch_main_queue(^{
                                       success ? success(result) : nil;
                                   });
                               } else {
                                   jm_dispatch_main_queue(^{
                                       success ? success(nil) : nil;
                                   });
                               }
                           }
                           failure:^(NSError *_Nonnull error) {
                               [self executeFailure:failure withError:error];
                           }];
}


/**
 对象带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 数据模型
 @param key 解析字段名称
 @param success 成功回调 数组
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *)requestWithMethod:(JMAPIMethod)method
                                       path:(NSString *)path
                                     params:(NSDictionary *)params
                            parseIntoAClass:(Class)klass
                                    withKey:(NSString *)key
                                    success:(void (^ _Nullable)(id _Nullable))success
                                    failure:(void (^ _Nullable)(NSError * _Nonnull))failure {
    return [self requestWithMethod:method
                              path:path
                            params:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = (NSDictionary *) responseObject;
                               if ([response[@"obj"] isKindOfClass:NSDictionary.class]) {
                                   NSDictionary *data = response[@"obj"];
                                   if (key && [[data objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                                       id result = [self parseIntoAClass:klass fromDict:[data objectForKey:key]];
                                       jm_dispatch_main_queue(^{
                                           success ? success(result) : nil;
                                       });
                                   } else {
                                       jm_dispatch_main_queue(^{
                                           success ? success(nil) : nil;
                                       });
                                   }
                               } else {
                                   jm_dispatch_main_queue(^{
                                       success ? success(nil) : nil;
                                   });
                               }
                           }
                           failure:^(NSError *_Nonnull error) {
                               [self executeFailure:failure withError:error];
                           }];
}


/**
 数据转型 数组

 @param klass 数据模型
 @param dictArr 源数据
 @return 转型后数组
 */
+ (NSArray *)parseIntoArrayOfClass:(Class)klass fromArray:(NSArray *)dictArr {
    if ([klass isSubclassOfClass:[JSONModel class]]) {
        if (!dictArr) {
            return @[];
        }
        
        __block NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dictArr.count];
        [dictArr enumerateObjectsUsingBlock:^(id _Nonnull dictionary, NSUInteger idx, BOOL *_Nonnull stop) {
            [array addObject:[[klass alloc] initWithDictionary:dictionary error:nil]];
        }];
        return array;
    }
    
    return @[];
}


/**
 数据转型 对象

 @param klass 数据模型
 @param dict 字典
 @return 转型后对象
 */
+ (nullable id)parseIntoAClass:(Class)klass fromDict:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    if ([klass isSubclassOfClass:[JSONModel class]]) {
        return [[klass alloc] initWithDictionary:dict error:nil];
    }
    
    return nil;
}


/**
 成功回调

 @param success 成功
 @param results 请求得到的数据
 */
+ (void)exectuteSuccess:(void (^ _Nullable)(NSArray *results))success withResults:(NSArray *)results {
    dispatch_async(dispatch_get_main_queue(), ^{
        success ? success(results) : nil;
    });
}


/**
 失败处理

 @param failure 失败
 @param error 错误信息
 */
+ (void)executeFailure:(void (^ _Nullable)(NSError *_Nonnull error))failure withError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithDictionary:error.userInfo];
    if (!userInfo[JMMETAERRMSGKEY]) {
        userInfo[JMMETAERRMSGKEY] = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    }
    
    NSError *errorr = [NSError errorWithDomain:JMMETAERRDOMIN
                                 code:error.code
                             userInfo:userInfo];
    
    if ([error.userInfo[JMMETAERRCODEKEY] integerValue] == 401) {
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            failure ? failure(errorr) : nil;
        });
        
    }
    
}

#pragma mark - 线程处理
void jm_dispatch_main_queue(dispatch_block_t block) {
    jm_dispatch_on_queue(dispatch_get_main_queue(), block);
}

void jm_dispatch_on_queue(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_async(queue, block);
}
@end

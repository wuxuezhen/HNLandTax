//
//  FITAPI.h
//  FitBody
//
//  Created by caiyi on 2018/8/21.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FITAPIMethod) {
    FITAPIMethodGet,
    FITAPIMethodPost,
    FITAPIMethodPut,
    FITAPIMethodDelete,
};

@interface FITAPI : NSObject

#pragma mark - GET、POST、PUT、DELETE 四请求方式
+ (NSURLSessionDataTask *_Nonnull)GET:(NSString *_Nonnull)path
                               params:(NSDictionary *_Nullable)params
                              success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                              failure:(void (^_Nullable)(NSError *_Nonnull error))failure;


+ (NSURLSessionDataTask *_Nonnull)POST:(NSString *_Nonnull)path
                                params:(NSDictionary *_Nullable)params
                               success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                               failure:(void (^_Nullable)(NSError *_Nonnull error))failure;


+ (NSURLSessionDataTask *_Nonnull)PUT:(NSString *_Nonnull)path
                               params:(NSDictionary *_Nullable)params
                              success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                              failure:(void (^_Nullable)(NSError *_Nonnull error))failure;


+ (NSURLSessionDataTask *_Nonnull)DELETE:(NSString *_Nonnull)path
                                  params:(NSDictionary *_Nullable)params
                                 success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                                 failure:(void (^_Nullable)(NSError *_Nonnull error))failure;


/**
 数组不带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 解析Model
 @param success 成功回调 数组
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(FITAPIMethod)method
                                               path:(NSString *_Nonnull)path
                                             params:(NSDictionary *_Nullable)params
                              parseIntoArrayOfClass:(Class _Nonnull)klass
                                            success:(void (^_Nullable)(NSArray *_Nullable results))success
                                            failure:(void (^_Nullable)(NSError *_Nonnull error))failure;
/**
 数组带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 解析model
 @param key 解析字段名称
 @param success 成功回调 数组
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(FITAPIMethod)method
                                               path:(NSString *_Nonnull)path
                                             params:(NSDictionary *_Nullable)params
                              parseIntoArrayOfClass:(Class _Nonnull)klass
                                            withKey:(NSString *_Nonnull)key
                                            success:(void (^ _Nullable)(NSArray *_Nullable results))success
                                            failure:(void (^ _Nullable)(NSError *_Nonnull error))failure;

/**
 对象不带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 解析model
 @param success 成功回调 对象
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(FITAPIMethod)method
                                               path:(NSString *_Nonnull)path
                                             params:(NSDictionary *_Nullable)params
                                    parseIntoAClass:(Class _Nonnull)klass
                                            success:(void (^_Nullable)(id _Nullable))success
                                            failure:(void (^_Nullable)(NSError *_Nonnull error))failure;

/**
 对象带key请求
 @param method 请求方式
 @param path 路径
 @param params 参数
 @param klass 解析model
 @param key 解析字段名称
 @param success 成功回调 对象
 @param failure 失败回调
 @return task
 */
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(FITAPIMethod)method
                                               path:(NSString *_Nonnull)path
                                             params:(NSDictionary *_Nonnull)params
                                    parseIntoAClass:(Class _Nonnull)klass
                                            withKey:(NSString *_Nonnull)key
                                            success:(void (^_Nullable)(id _Nullable))success
                                            failure:(void (^_Nullable)(NSError *_Nonnull error))failure;

+ (NSArray *_Nonnull)parseIntoArrayOfClass:(Class _Nonnull)klass
                                 fromArray:(NSArray *_Nonnull)dictArr;
@end

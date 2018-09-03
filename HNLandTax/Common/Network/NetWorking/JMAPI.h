//
//  JMAPI.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JMAPIMethod) {
    JMAPIMethodGet,
    JMAPIMethodPost,
    JMAPIMethodPut,
    JMAPIMethodDelete,
};

@interface JMAPI : NSObject

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
 现在解析跟字段有result 、obj 两种，下面请求方式只做了字段为obj的处理。
 由于后端没有统一解析跟字段，下面直接请求转型方式根据实际情况使用！
 解决方法：添加一个跟字段RootKey 默认为result（后端新版接口跟字段为result），否则以后端为准传入跟字段
 因为下面方法代码中已经有多处调用下面方法，暂不改动，带后端统一后，再做改动
 */

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
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(JMAPIMethod)method
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
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(JMAPIMethod)method
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
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(JMAPIMethod)method
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
+ (NSURLSessionDataTask *_Nonnull)requestWithMethod:(JMAPIMethod)method
                                               path:(NSString *_Nonnull)path
                                             params:(NSDictionary *_Nonnull)params
                                    parseIntoAClass:(Class _Nonnull)klass
                                            withKey:(NSString *_Nonnull)key
                                            success:(void (^_Nullable)(id _Nullable))success
                                            failure:(void (^_Nullable)(NSError *_Nonnull error))failure;

+ (NSArray *_Nonnull)parseIntoArrayOfClass:(Class _Nonnull)klass
                                 fromArray:(NSArray *_Nonnull)dictArr;

@end


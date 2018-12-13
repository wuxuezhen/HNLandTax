//
//  FITNetRequst.h
//  FitBody
//
//  Created by caiyi on 2018/8/28.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FITAPI.h"
#import "FITConstants.h"

typedef NS_ENUM(NSInteger, FITParseMethod) {
    FITParseMethodObject     =  0,
    FITNOParseMethodObject,
    FITParseMethodList,
    FITNOParseMethodList
};

@interface FITNetRequst : NSObject

-(instancetype) initWithPath:(NSString *)path
               requestMethod:(FITAPIMethod)requestMethod
                 parseMethod:(FITParseMethod)parseMethod
                  parameters:(id)parameters
               responseModel:(Class)responsModel;


/**
 接口路径
 */
@property (nonatomic, copy) NSString *path;


/**
 请求方式
 */
@property (nonatomic, assign) FITAPIMethod requestMethod;


/**
 解析方式
 */
@property (nonatomic, assign) FITParseMethod parseMethod;


/**
 参数
 */
@property (nonatomic, strong) id parameters;


/**
 解析结果 类
 */
@property (nonatomic, strong) Class  responseModel;

@end

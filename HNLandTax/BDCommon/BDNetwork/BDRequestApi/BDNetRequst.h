//
//  BDNetRequst.h
//  FitBody
//
//  Created by caiyi on 2018/8/28.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDAPI.h"
#import "BDConstants.h"

typedef NS_ENUM(NSInteger, BDParseMethod) {
    BDParseMethodObject     =  0,
    BDNOParseMethodObject,
    BDParseMethodList,
    BDNOParseMethodList,
    BDParseMethodObjectWithKey,
    BDParseMethodListWithKey
};

@interface BDNetRequst : NSObject

-(instancetype) initWithPath:(NSString *)path
               requestMethod:(BDAPIMethod)requestMethod
                 parseMethod:(BDParseMethod)parseMethod
                  parameters:(id)parameters
               responseModel:(Class)responsModel;


/**
 接口路径
 */
@property (nonatomic, copy) NSString *path;


/**
 请求方式
 */
@property (nonatomic, assign) BDAPIMethod requestMethod;


/**
 解析方式
 */
@property (nonatomic, assign) BDParseMethod parseMethod;

/**
 解析路径
 */
@property (nonatomic, copy) NSString *parseKey;

/**
 参数
 */
@property (nonatomic, strong) id parameters;


/**
 解析结果 类
 */
@property (nonatomic, strong) Class  responseModel;

@end

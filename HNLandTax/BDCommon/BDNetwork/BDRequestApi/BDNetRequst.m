//
//  BDNetRequst.m
//  FitBody
//
//  Created by caiyi on 2018/8/28.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "BDNetRequst.h"
#import <JSONModel/JSONModel.h>
@implementation BDNetRequst

-(instancetype)initWithPath:(NSString *)path
              requestMethod:(BDAPIMethod)requestMethod
                parseMethod:(BDParseMethod)parseMethod
                 parameters:(id)parameters
              responseModel:(__unsafe_unretained Class)responsModel{
    if (self = [super init]) {
        _path          = path;
        _requestMethod = requestMethod;
        _parseMethod   = parseMethod;
        _responseModel = responsModel;
        
        if (parameters && [parameters isKindOfClass: JSONModel.class]) {
            _parameters = [(JSONModel *)parameters toDictionary];
        }else{
            _parameters = parameters;
        }
    }
    return self;
}

-(id)parameters{
    return (_parameters && [_parameters isKindOfClass: JSONModel.class]) ? [(JSONModel *)_parameters toDictionary] :_parameters;
}
@end

//
//  JMJsonHandle.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMJsonHandle : NSObject

// 字典转成JSON 字符串
+(NSString *)dictionaryToJson:(id)dic;

// JSON 字符串 转字典
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

/**下划线转驼峰**/
+ (NSString *)stringConverToHump:(NSString *)key;
@end

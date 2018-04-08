//
//  JMJsonHandle.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMJsonHandle.h"

@implementation JMJsonHandle

// JSON 字符串 转字典
+(NSString *)dictionaryToJson:(id)dic {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
// 字典转成JSON 字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    if ([jsonString isEqualToString:@""]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)stringConverToHump:(NSString *)key {
    NSMutableString *str = [NSMutableString stringWithString:key];
    while ([str containsString:@"_"]) {
        NSRange range = [str rangeOfString:@"_"];
        if (range.location + 1 < [str length]) {
            char c = [str characterAtIndex:range.location+1];
            [str replaceCharactersInRange:NSMakeRange(range.location, range.length+1)
                               withString:[[NSString stringWithFormat:@"%c",c] uppercaseString]];
        }
    }
    return str;
}

@end

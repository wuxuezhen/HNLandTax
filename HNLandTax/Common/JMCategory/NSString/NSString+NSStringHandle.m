//
//  NSString+NSStringHandle.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/4.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "NSString+NSStringHandle.h"

@implementation NSString (NSStringHandle)


/**
 获取字符串的首字母

 @return 首字母字符
 */
-(char)firstLetter{
    char firstChar;
    if ([self isChinaFirst]){
        NSString *pinyinName = [self transformPinYinWithChinese];
        firstChar = [pinyinName characterAtIndex:0];
    }else{
        if ([self isEnglishFirst]){
            NSString *subString = [[self substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            firstChar = [subString characterAtIndex:0];
        }else{
            firstChar = '#';
        }
    }
    return firstChar;
}


/**
 判断字符串是不是中文

 @return YES/NO
 */
- (BOOL)isChinaFirst{
    if (self.length == 0) return NO;
    //判断是不是以字母开头
    //是否以中文开头（unicode中文编码范围是0x4e00 ～ 0x9fa5）
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [self getBytes:buffer
                  maxLength:2
                 usedLength:NULL
                   encoding:NSUTF16LittleEndianStringEncoding
                    options:NSStringEncodingConversionExternalRepresentation
                      range:range remainingRange:NULL];
    
    return (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5));
}


/**
 判断字符串是不是英文

 @return YES/NO
 */
- (BOOL)isEnglishFirst{
    if (self.length == 0) return NO;
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ZIMU];
    return [regextestA evaluateWithObject:self];
}



/**
 中文转拼音

 @return 拼音字符串
 */
- (NSString *)transformPinYinWithChinese{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

    
@end

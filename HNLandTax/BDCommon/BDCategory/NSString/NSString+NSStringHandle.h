//
//  NSString+NSStringHandle.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/4.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringHandle)

/**
 获取字符串的首字母
 
 @return 首字母字符
 */
-(char)firstLetter;


/**
 判断字符串是不是中文
 
 @return YES/NO
 */
- (BOOL)isChinaFirst;


/**
 判断字符串是不是英文
 
 @return YES/NO
 */
- (BOOL)isEnglishFirst;



/**
 中文转拼音
 
 @return 拼音字符串
 */
- (NSString *)transformPinYinWithChinese;

@end

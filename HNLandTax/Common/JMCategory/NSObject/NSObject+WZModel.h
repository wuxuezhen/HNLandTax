//
//  NSObject+WZModel.h
//  MGTools
//
//  Created by Alfred Zhang on 2018/2/28.
//  Copyright © 2018年 MIGU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (WZModel)

- (BOOL)wz_boolValue;

- (NSInteger)wz_integerValue;

- (CGFloat)wz_floatValue;

@property (nonatomic, strong) id wzOriginData;

@end

//
//  NSObject+WZModel.m
//  MGTools
//
//  Created by Alfred Zhang on 2018/2/28.
//  Copyright © 2018年 MIGU. All rights reserved.
//

#import "NSObject+WZModel.h"
#import <objc/runtime.h>

@implementation NSObject (WZModel)

- (BOOL)wz_boolValue {
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"0"]) {
            return NO;
        }else {
            return YES;
        }
    }else{
        return NO;
    }
}

- (NSInteger)wz_integerValue {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) integerValue];
    }else{
        return 0;
    }
}

- (CGFloat)wz_floatValue {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) floatValue];
    }else{
        return 0;
    }
}

-(id)wzOriginData{
	return objc_getAssociatedObject(self, _cmd);;
}

-(void)setWzOriginData:(id)wzOriginData{
	objc_setAssociatedObject(self, @selector(wzOriginData), wzOriginData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

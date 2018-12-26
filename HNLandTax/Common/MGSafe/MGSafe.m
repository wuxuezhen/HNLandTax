//
//  MGSafe.m
//  MiGuKit
//
//  Created by 宋乃银 on 2018/12/12.
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import "MGSafe.h"
#import "NSObject+Object.h"
#import "NSArray+MGSafe.h"
#import "NSDictionary+MGSafe.h"

@implementation MGSafeArray
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
- (id)objectAtIndex:(NSUInteger)index {
    return [self.originArray mg_objectAtIndex:index];
}
#pragma clang diagnostic pop

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if ([self.originArray isKindOfClass:NSMutableArray.class]) {
        [(NSMutableArray *)self.originArray mg_setObject:obj atIndexedSubscript:idx];
    }
}

@end


@implementation MGSafeDictionary
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
- (id)objectForKey:(id)aKey {
    return [self.originDict mg_objectForKey:aKey];
}

#pragma clang diagnostic pop

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if ([self.originDict isKindOfClass:NSMutableDictionary.class]) {
        [(NSMutableDictionary *)self.originDict mg_setObject:obj forKey:key];
    }
}

@end

//
//  NSDictionary+MGSafe.m
//  MiGuKit
//
//  Created by 熊智凡 on 2018/12/10.
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import "NSDictionary+MGSafe.h"

@implementation NSDictionary (MGSafe)

- (BOOL)mg_writeToURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)error {
    if (url == nil) {
        return NO;
    }else {
        return [self writeToURL:url error:error];
    }
}

+ (instancetype)mg_dictionaryWithObject:(id)object forKey:(id)key {
    if (object == nil || key == nil) {
        return nil;
    }else {
        return [NSDictionary dictionaryWithObject:object forKey:key];
    }
}

- (id)mg_objectForKey:(id)aKey {
    if (aKey) {
        return [self objectForKey:aKey];
    }
    return nil;
}

- (id)mg_valueForKey:(id)aKay {
    if (aKay) {
        return [self valueForKey:aKay];
    }
    return nil;
}

- (void)mg_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey && [self isKindOfClass:NSMutableDictionary.class]) {
        [(NSMutableDictionary *)self setObject:anObject forKey:aKey];
    }
}

- (void)mg_setValue:(id)value forKey:(NSString *)key {
    if (key && [self isKindOfClass:NSMutableDictionary.class]) {
        [(NSMutableDictionary *)self setValue:value forKey:key];
    }
}

@end


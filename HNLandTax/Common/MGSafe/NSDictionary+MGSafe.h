//
//  NSDictionary+MGSafe.h
//  MiGuKit
//
//  Created by 熊智凡 on 2018/12/10.
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MGSafe)

- (BOOL)mg_writeToURL:(NSURL *)url error:(NSError **)error API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));

+ (instancetype)mg_dictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

- (id)mg_objectForKey:(id)aKey;

- (id)mg_valueForKey:(id)aKay;

@end

@interface NSMutableDictionary (MGSafe)

- (void)mg_setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)mg_setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

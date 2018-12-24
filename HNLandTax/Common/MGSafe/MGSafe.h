//
//  MGSafe.h
//  MiGuKit
//
//  Created by 宋乃银 on 2018/12/12.
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSafeArray<__covariant ObjectType> : NSObject
@property (nonatomic, weak) NSArray *originArray;
- (ObjectType _Nullable)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface MGSafeMutableArray<ObjectType> : MGSafeArray<ObjectType>
- (void)setObject:(ObjectType _Nullable)obj atIndexedSubscript:(NSUInteger)idx;
@end

@interface MGSafeDictionary<__covariant KeyType, __covariant ObjectType> : NSObject
@property (nonatomic, weak) NSDictionary *originDict;

- (ObjectType _Nullable)objectForKeyedSubscript:(KeyType<NSCopying>_Nullable)key;
@end

@interface MGSafeMutableDictionary<KeyType, ObjectType> : MGSafeDictionary<KeyType, ObjectType>
- (void)setObject:(_Nullable ObjectType)obj forKeyedSubscript:(KeyType<NSCopying>_Nullable)key;
@end

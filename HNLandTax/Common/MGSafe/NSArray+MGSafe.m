//
//  NSArray+MGSafe.m
//  MiGuKit
//
//  Created by Alfred on 2018/12/10.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import "NSArray+MGSafe.h"

@implementation NSArray (MGSafe)

- (BOOL)isSafeRange:(NSRange)range {
    return ((range.location + range.length) <= self.count);
}

- (BOOL)isSafeIndexes:(NSIndexSet *)indexes {
    if (indexes && self.count > 0 && indexes.firstIndex >= 0 && indexes.lastIndex < self.count) {
        return YES;
    }
    return NO;
}

- (id)mg_objectAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSUInteger)mg_indexOfObject:(id)anObject inRange:(NSRange)range {
    if (![self isSafeRange:range]) {
        return -1;
    }else {
        return [self indexOfObject:anObject inRange:range];
    }
}

- (NSUInteger)mg_indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    if (![self isSafeRange:range]) {
        return -1;
    }else {
        return [self mg_indexOfObjectIdenticalTo:anObject inRange:range];
    }
}

- (NSArray *)mg_arrayByAddingObject:(id)anObject {
    if (anObject == nil) {
        return nil;
    }else {
        return [self arrayByAddingObject:anObject];
    }
}

- (NSArray *)mg_subarrayWithRange:(NSRange)range {
    if (![self isSafeRange:range]) {
        return nil;
    }else {
        return [self subarrayWithRange:range];
    }
}

- (BOOL)mg_writeToURL:(NSURL *)url error:(NSError *__autoreleasing *)error {
    if (url == nil) {
        return NO;
    }else {
        return [self writeToURL:url error:error];
    }
}

- (NSArray *)mg_objectsAtIndexes:(NSIndexSet *)indexes {
    if ([self isSafeIndexes:indexes]) {
        return [self objectsAtIndexes:indexes];
    } else {
        return nil;
    }
}

- (id)mg_objectAtIndexedSubscript:(NSUInteger)idx {
    return [self mg_objectAtIndex:idx];
}

@end


@implementation NSMutableArray(MGSafe)


- (void)mg_addObject:(id)anObject {
    if (anObject == nil) {
    }else {
        [self addObject:anObject];
    }
}

- (void)mg_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index >= 0 && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)mg_removeObjectAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)mg_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= 0 && index < self.count && anObject) {
         [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)mg_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1 >= 0 && idx1 < self.count && idx2 >= 0 && idx2 < self.count) {
        [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }
}

- (void)mg_removeObject:(id)anObject inRange:(NSRange)range {
    if (![self isSafeRange:range]) {
    }else {
        [self removeObject:anObject inRange:range];
    }
}

- (void)mg_removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    if (![self isSafeRange:range]) {
    }else {
        [self mg_removeObjectIdenticalTo:anObject inRange:range];
    }
}

- (void)mg_removeObjectsInRange:(NSRange)range {
    if (![self isSafeRange:range]) {
    }else {
        [self removeObjectsInRange:range];
    }
}

-(void)mg_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    if (![self isSafeRange:range] || otherArray == nil || ![otherArray isSafeRange:otherRange]) {
    }else {
        [self replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
    }
}

- (void)mg_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
    if (![self isSafeRange:range] || otherArray == nil) {
    }else {
        [self replaceObjectsInRange:range withObjectsFromArray:otherArray];
    }
}

- (void)mg_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (objects && indexes && objects.count == indexes.count && indexes.firstIndex >= 0 && indexes.firstIndex <= self.count) {
        [self insertObjects:objects atIndexes:indexes];
    }
}

- (void)mg_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    if ([self isSafeIndexes:indexes]) {
        [self removeObjectsAtIndexes:indexes];
    }
}

- (void)mg_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    if ([self isSafeIndexes:indexes] && objects != nil && indexes.count == objects.count) {
        [self replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

- (void)mg_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (obj) {
        if (idx >= 0) {
            if (idx < self.count) {
                [self replaceObjectAtIndex:idx withObject:obj];
            } else if (idx == self.count) {
                [self mg_addObject:obj];
            }
        }
    }
}

@end

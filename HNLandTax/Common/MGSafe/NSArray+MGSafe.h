//
//  NSArray+MGSafe.h
//  MiGuKit
//
//  Created by Alfred on 2018/12/10.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (MGSafe)

- (ObjectType)mg_objectAtIndex:(NSUInteger)index;

- (NSUInteger)mg_indexOfObject:(ObjectType)anObject inRange:(NSRange)range;

- (NSUInteger)mg_indexOfObjectIdenticalTo:(ObjectType)anObject inRange:(NSRange)range;

- (NSArray<ObjectType> *)mg_arrayByAddingObject:(ObjectType)anObject;


- (NSArray<ObjectType> *)mg_subarrayWithRange:(NSRange)range;

- (BOOL)mg_writeToURL:(NSURL *)url error:(NSError **)error API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));

- (NSArray<ObjectType> *)mg_objectsAtIndexes:(NSIndexSet *)indexes;

- (ObjectType)mg_objectAtIndexedSubscript:(NSUInteger)idx API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));

@end


@interface NSMutableArray<ObjectType> (MGSafe)

- (void)mg_addObject:(ObjectType)anObject;

- (void)mg_insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

- (void)mg_removeObjectAtIndex:(NSUInteger)index;

- (void)mg_replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

- (void)mg_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (void)mg_removeObject:(ObjectType)anObject inRange:(NSRange)range;

- (void)mg_removeObjectIdenticalTo:(ObjectType)anObject inRange:(NSRange)range;

- (void)mg_removeObjectsInRange:(NSRange)range;

- (void)mg_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray range:(NSRange)otherRange;

- (void)mg_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<ObjectType> *)otherArray;

- (void)mg_insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;

- (void)mg_removeObjectsAtIndexes:(NSIndexSet *)indexes;

- (void)mg_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<ObjectType> *)objects;

- (void)mg_setObject:(ObjectType)obj atIndexedSubscript:(NSUInteger)idx API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));

@end

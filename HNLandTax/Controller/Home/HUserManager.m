//
//  HUserManager.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/9/12.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "HUserManager.h"
#define LOCAL_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/cacheImage"]
@interface HUserManager()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end
@implementation HUserManager
+(instancetype)manager{
    static HUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:LOCAL_CACHE_PATH]) {
            manager = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_CACHE_PATH];
            
        }else{
            manager = [[HUserManager alloc] init];
            manager.dict = [[NSMutableDictionary alloc]init];;
        }
    });
    return manager;
}

-(void)cacheObject:(id)object forKey:(NSString *)key{
    if (![self.dict objectForKey:key] && object) {
        [self.dict setObject:object forKey:key];
    }
}

-(id)getCacheObjectForKey:(NSString *)key{
    return [self.dict objectForKey:key];
}

/***归档***/
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dict forKey:@"dict"];
}
/***解档***/
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.dict = [coder decodeObjectForKey:@"dict"];
    }
    return self;
}

-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}
@end

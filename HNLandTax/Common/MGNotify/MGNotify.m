//
//  MGNotify.m
//  MiGuKit
//
//  Created by zhgz on 2018/4/9.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import "MGNotify.h"
#import <objc/runtime.h>
#define kInstanceEventBlockKey @"kInstanceEventBlockKey"

@interface NSObject(MGNotify)@end

@implementation NSObject(MGNotify)

- (void)setMgNotifyStrategy:(NSMutableDictionary *)mgNotifyStrategy {
    objc_setAssociatedObject(self, @selector(mgNotifyStrategy), mgNotifyStrategy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)mgNotifyStrategy{
    return objc_getAssociatedObject(self, _cmd);
}

@end


@interface MGNotify()
@property (nonatomic,strong) NSMutableDictionary *notifyDic;
@end

@implementation MGNotify

+ (MGNotify *)sharedInstance {
	static MGNotify *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
		instance.notifyDic = [NSMutableDictionary new];
	});
	return instance;
}

+ (void)notify:(nonnull NSString *)eventName info:(nullable id)info {
	NSPointerArray *array = [MGNotify sharedInstance].notifyDic[eventName];
	if(array!=nil){
        for(id obj in array){
            NotifyBlock block =((NSObject*)obj).mgNotifyStrategy[eventName];
            block ? block(info) : nil;
        }
    }
}

+ (void)registerNotify:(nonnull NSString *)eventName
              instance:(nonnull id)instance
                 block:(nullable NotifyBlock)block {
    
	if([MGNotify sharedInstance].notifyDic[eventName] == nil){
        [MGNotify sharedInstance].notifyDic[eventName] = [NSPointerArray weakObjectsPointerArray];
    }
	NSPointerArray *array=[MGNotify sharedInstance].notifyDic[eventName];
	if(!instance){
		if(((NSObject*)instance).mgNotifyStrategy==nil){
            ((NSObject*)instance).mgNotifyStrategy = [NSMutableDictionary new];
        }
		((NSObject*)instance).mgNotifyStrategy[eventName] = block ? block :^(id info){};
		[array addPointer:(__bridge void *)instance];
	}
}

@end

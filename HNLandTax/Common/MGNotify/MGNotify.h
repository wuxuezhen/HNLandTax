//
//  MGNotify.h
//  MiGuKit
//
//  Created by zhgz on 2018/4/9.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MG_EVENT_KEY(name) static NSString *const name = @#name;

typedef void (^NotifyBlock)(__nullable id info);

@interface MGNotify : NSObject

+ (void)notify:(nonnull NSString *)eventName info:(nullable id)info;

+ (void)registerNotify:(nonnull NSString *)eventName
              instance:(nonnull id)instance
                 block:(nullable NotifyBlock)block;

@end

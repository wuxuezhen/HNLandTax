//
//  HUserManager.h
//  HNLandTax
//
//  Created by 吴振振 on 2018/9/12.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FITDownSession.h"
@interface HUserManager : NSObject
+(instancetype)manager;

-(void)cacheObject:(id)object forKey:(NSString *)key;

-(id)getCacheObjectForKey:(NSString *)key;


-(void)addTask:(FITDownSession *)task;

-(void)deleteTaskForKey:(NSString *)key;

-(FITDownSession *)taskForKey:(NSString *)key;

@end

//
//  JMCoreDataManager.m
//  HNLandTax
//
//  Created by wzz on 2018/11/19.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "JMCoreDataManager.h"

@implementation JMCoreDataManager

/**
 CoreData 单例
 @return 单例
 */

+ (JMCoreDataManager *)manager{
    static JMCoreDataManager *instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMCoreDataManager alloc]init];
    });
    return instance;
}

/**
 保存应用程序托管对象上下文中的更改
 */

- (void)saveContext {
    NSManagedObjectContext *context = self.managerContenxt;
    NSError*error =nil;
    if(context !=nil) {
        if([context hasChanges] && ![context save:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            //abort();
        }
    }
}

/**
 获取文件位置
 @paramNSURL 路径
 @return path
 */
- (NSURL*)getDocumentUrlPath{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 懒加载
/**
 懒加载 managerContenxt
 */
- (NSManagedObjectContext *)managerContenxt{
    
    if (!_managerContenxt) {
        if(!self.managerDinator) {
            return nil;
        }
        _managerContenxt = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managerContenxt setPersistentStoreCoordinator:self.managerDinator];///设置存储调度器
    }
    
    return _managerContenxt;
}

/**
 懒加载模型对象
 */
-(NSManagedObjectModel *)managerModel{
    
    if (!_managerModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FitBody" withExtension:@"momd"];
        _managerModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];;
    }
    
    return _managerModel;
}

/**
 存储调度器
 */
-(NSPersistentStoreCoordinator *)managerDinator{
    
    if (!_managerDinator) {
        _managerDinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managerModel];
        
        /**
         * type:一般使用数据库存储方式NSSQLiteStoreType
         * configuration:配置信息 一般无需配置
         * URL:要保存的文件路径
         * options:参数信息 一般无需设置
         */

        NSError *error          = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        NSURL *url              = [[self getDocumentUrlPath] URLByAppendingPathComponent:@"FitBody.sqlite"
                                                                             isDirectory:YES];
        NSDictionary* options   = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),NSInferMappingModelAutomaticallyOption:@(YES)};
        
        if (![_managerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _managerDinator;
}

@end

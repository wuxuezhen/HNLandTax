//
//  JMCoreDataManager.h
//  HNLandTax
//
//  Created by wzz on 2018/11/19.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN

@interface JMCoreDataManager : NSObject

+(JMCoreDataManager *)manager;

///管理对象上下文
@property(strong, nonatomic)NSManagedObjectContext *managerContenxt;

///模型对象
@property(strong, nonatomic)NSManagedObjectModel *managerModel;

///存储调度器
@property(strong, nonatomic)NSPersistentStoreCoordinator *managerDinator;

@end

NS_ASSUME_NONNULL_END

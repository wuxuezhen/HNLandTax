//
//  c
//  HNLandTax
//
//  Created by wzz on 2018/11/19.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WZVideo.h"
#import "JMVideo+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface JMCoreDataManager : NSObject

+(JMCoreDataManager *)manager;

///管理对象上下文
@property(strong, nonatomic)NSManagedObjectContext *managerContenxt;

///模型对象
@property(strong, nonatomic)NSManagedObjectModel *managerModel;

///存储调度器
@property(strong, nonatomic)NSPersistentStoreCoordinator *managerDinator;

- (void)saveContext;


/**
 增
 @param data 新数据
 */
-(void)addData:(WZVideo *)data;


/**
 删
 @param videoUrl url
 */
- (void)deleteData:(NSString *)videoUrl;


/**
 查
 @param videoUrl 年龄
 @return 查询结果
 */
-(NSArray *)checkData:(NSString *)videoUrl;


/**
 改
 @param data
 */
- (void)updateData:(WZVideo *)data;


/**
 数据排序
 
 @return 排序结果
 */
- (NSArray *)sortAllData;

@end

NS_ASSUME_NONNULL_END

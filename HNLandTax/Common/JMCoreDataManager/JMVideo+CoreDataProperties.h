//
//  JMVideo+CoreDataProperties.h
//  HNLandTax
//
//  Created by wzz on 2018/12/10.
//  Copyright © 2018 WYW. All rights reserved.
//
//

#import "JMVideo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JMVideo (CoreDataProperties)

+ (NSFetchRequest<JMVideo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *videoUrl;
@property (nullable, nonatomic, copy) NSString *key;
@property (nonatomic) BOOL isDelete;

@end

NS_ASSUME_NONNULL_END

//
//  JMVideo+CoreDataProperties.m
//  HNLandTax
//
//  Created by wzz on 2018/12/10.
//  Copyright © 2018 WYW. All rights reserved.
//
//

#import "JMVideo+CoreDataProperties.h"

@implementation JMVideo (CoreDataProperties)

+ (NSFetchRequest<JMVideo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"JMVideo"];
}

@dynamic name;
@dynamic title;
@dynamic videoUrl;
@dynamic key;
@dynamic isDelete;

@end

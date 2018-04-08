//
//  UIViewController+Navigation.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/2/23.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMLocationNavigation.h"
#import "JMMapModel.h"
@interface UIViewController (Navigation)
-(void)jm_navigation:(CLLocationCoordinate2D)userLocation Anddestination:(CLLocationCoordinate2D)destinationCoordinate dname:(NSString *)dname;
@end

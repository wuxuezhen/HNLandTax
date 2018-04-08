//
//  UIViewController+Navigation.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/2/23.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)


-(void)jm_navigation:(CLLocationCoordinate2D)userLocation Anddestination:(CLLocationCoordinate2D)destinationCoordinate dname:(NSString *)dname{
    NSArray *arr = [JMLocationNavigation canOpenMaps:userLocation
                                      Anddestination:destinationCoordinate
                                               dname:dname?:@"终点"];
    [self routeNavigationByMap:arr];
}

/**路线导航**/
-(void)routeNavigationByMap:(NSArray *)maps{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0;  i < maps.count; i ++) {
        JMMapModel *map = maps[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:map.name
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           if (map.mapType == kMapTypeApple) {
                                                               
                                                               MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                                                               //终点
                                                               //                CLGeocoder *geo = [[CLGeocoder alloc]init];
                                                               //                [geo reverseGeocodeLocation:destination completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                                                               //                    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemarks.lastObject];
                                                               
                                                               MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:map.dCoordinate]];
                                                               toLocation.name = map.dname;
                                                               //默认驾车
                                                               [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                                                                              launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                              MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],
                                                                                              MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
                                                               
                                                               
                                                               
                                                           }else{
                                                               
                                                               if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:map.url] options:@{} completionHandler:^(BOOL success) {
                                                                       NSLog(@"scheme调用结束");
                                                                   }];
                                                               } else {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:map.url]];
                                                               }
                                                           }
                                                           
                                                       }];
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end

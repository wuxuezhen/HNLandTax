//
//  UIViewController+AppSettings.m
//  TuoDian
//
//  Created by Mac Pro on 2017/10/13.
//  Copyright © 2017年 wxz. All rights reserved.
//

#import "UIViewController+AppSettings.h"

@implementation UIViewController (AppSettings)
- (void)jm_openAppSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if( [[[UIDevice currentDevice] systemVersion] floatValue] <= 10.0 && [[UIApplication sharedApplication] canOpenURL:url] ) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url
                                              options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}
                                    completionHandler:^(BOOL success) {
                                        
                                    }];
        }
    }
}


-(void)jm_callPhone:(NSString *)phone{
    if (!phone || phone.length == 0) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"tel:%@",phone];
    [self openURL:url];
}



-(void)openURL:(NSString *)url{
    if ([self canOpenURL:url]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]
                                                  options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}
                                        completionHandler:^(BOOL success) {
                                            
                                        }];
            }
        }
        
    }
}
-(BOOL)canOpenURL:(NSString *)url{
    if (url && url.length > 0) {
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
    }else{
        return NO;
    }
}
@end

//
//  MGAuthorizationManager.h
//  MiGuKit
//
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MGAuthorizationType) {
    MGAuthorizationTypePhotoLibrary, // 相册
    MGAuthorizationTypeCamera, // 相机
    MGAuthorizationTypeMicrophone, // 麦克风
    MGAuthorizationTypeContacts, // 联系人
    MGAuthorizationTypeCalendars, // 日历
    MGAuthorizationTypeReminder, // 备忘录
//    MGAuthorizationTypeNotication, // 通知
    
};

@interface MGAuthorizationManager : NSObject

+ (void)requestAuthorization:(MGAuthorizationType)type completionHandler:(void(^)(BOOL granted, BOOL isFirst))completionHandler;

+ (void)requestAuthorization:(MGAuthorizationType)type showAlert:(BOOL)showAlert completionHandler:(void(^)(BOOL granted, BOOL isFirst))completionHandler;

@end

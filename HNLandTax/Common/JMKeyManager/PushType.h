//
//  PushType.h
//  TuoDian
//
//  Created by rifei wang on 2017/6/13.
//  Copyright © 2017年 wxz. All rights reserved.
//
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题


#import <Foundation/Foundation.h>


static NSString *PUSH_EXTRA = @"EXTRA";

static NSString *PUSH_MESSAGEID = @"messageId";

static NSString *PUSH_INVITED = @"invited";


@interface PushType : NSObject

@end

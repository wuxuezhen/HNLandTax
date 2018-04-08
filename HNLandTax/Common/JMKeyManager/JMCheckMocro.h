//
//  JMCheckMocro.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/21.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#ifndef JMCheckMocro_h
#define JMCheckMocro_h

//密码最大长度
#define kMAX_LENGTH_PASSWORD  12
//密码最小长度
#define kMIN_LENGTH_PASSWORD  6
//手机号长度
#define kLENGTH_PHONE_NUMBER  11
//验证码长度
#define kSMS_CODE_LENGTH  6
//用户昵称最短长度
#define kMIN_LENGTH_NICK_NAME 2
//用户昵称最大长度
#define kMAX_LENGTH_NICK_NAME 12


//验证码提示信息
#define kEM_VACODE_EMPTY     @"尚未输入验证码"
#define kEM_VACODE_ERROR    @"验证码不正确"

//手机号提示信息
#define kEM_PHONE_EMPTY     @"尚未输入手机号"
#define kEM_OLD_PHONE_ERROR @"旧手机号错误"
#define kEM_PHONE_ERROR     @"手机号不正确"

//昵称提示信息
#define kEM_NICK_NAME_EMPTY  @"尚未输入昵称"
#define kEM_NICK_NAME_ERROR  @"昵称输入错误"

//密码提示信息
#define kEM_PASS_WORD_EMPTY  @"尚未输入密码"
#define kEM_PASS_WORD_ERROR  @"密码输入错误"
#define KEM_OLD_PASS_WORD_EMPTY @"尚未输入原密码"
#define KEM_OLD_PASS_WORD_ERROE @"旧密码输入错误"
#define kEM_PASS_WORD_NOT_SAME  @"两次密码不一致"
#define kEM_PASS_WORD_TWO  @"请再次输入密码"
//选择头像提示信息
#define kEM_ICON_EMPTY  @"尚未选择用户头像"

//选择用户性别提示信息
#define kEM_SEX_EMPTY  @"尚未选择性别"

//选择用户生日提示信息
#define kEM_BIRTHDAY_EMPTY @"尚未选择出生年月"

//选择用户体重提示信息
#define kEM_USER_WEIGHT_EMPTY @"尚未选择体重"
//选择用户身高提示信息
#define kEM_USER_HEIGHT_EMPTY @"尚未选择身高"
//选择用户地区提示信息
#define kEM_USER_AREA_EMPTY  @"尚未选择地区"

#endif /* JMCheckMocro_h */

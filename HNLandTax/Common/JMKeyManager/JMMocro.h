//
//  JMMocro.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/21.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#ifndef JMMocro_h
#define JMMocro_h


/**
 * 放置一些第三方常量。 友盟 极光
 */

/**
 * 友盟AppKey
 */
#define kUMSocicalAppKey @"57dea5ef67e58e4b85002d3e"

#define kUMSocialNormalColor Hex_Color(@"#262626")
#define kUMSocialCancelButtonColor Hex_Color(@"#424140")

/**
 * 新浪
 */
#define kSocialSinaKey  @"1392012578"
#define kSocialSinaSecret @"a8caaa160a21c54fa0c24c6189038fb9"
#define kSocialSinaRedirectURL @"http://sns.whalecloud.com/sina2/callback"
/**
 * 腾讯QQ
 */
#define kSocialQQAppID  @"1106087664"
#define kSocialQQAppKey @"3uNGjeWRDuGyD1OD"
#define kSocialQQRedirectURL @"http://mobile.umeng.com/social"
/**
 *  微信
 */
#define kSocialWechatKey @"wxe3430c6e060bbcee"
#define kSocialWechatSecret @"1a8961b20da8adf3ec9e6b632833e8b7"
#define kSocialWechatRedirectURL @"http://mobile.umeng.com/social"

//支付
#define kWechatPartnerId  @"1480937712"
#define kWechatPrePayIdURL  @"https://api.mch.weixin.qq.com/pay/unifiedorder"
/**
 * 极光
 */

#define kJPushAppKey @"1ea60d924c5a843c43efd727"
#define kJPushMasterSecret @"81d1cab5645beaac9449fdd5"

/**
 * 阿里云
 */

#define kAliCloudOSSEndPoint @"https://oss-cn-shenzhen.aliyuncs.com"
#define kAliCloudOSSBucketName @"weidu-proc"

#define kAliCloudOSSAccessPrefix @"http://images.weidu.xin/"
#define kAliCloudOSSThumnailSuffix @"?x-oss-process=image/resize,m_lfit,w_500/quality,Q_60"
#define kAliCloudOSSWIFISuffix @"?x-oss-process=image/resize,m_lfit,w_1000/quality,Q_60"
//#define kAliCloud

#define kALIYUNCLOUDUPLOADIMAGEFILEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"aliYunUploadImageFilePath.png"]

/**
 * 高德
 */
#define kAMapServiceAPIKey  @"6c9162ec3f6dbdca0cf33c58ac9dfd73"

#endif /* JMMocro_h */

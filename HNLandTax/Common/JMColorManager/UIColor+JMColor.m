//
//  UIColor+JMColor.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/20.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "UIColor+JMColor.h"


@implementation UIColor (JMColor)

+(UIColor *)jm_backgroudgaryColor{
    return JM_RGB(229, 233, 234, 1);
}

+(UIColor *)jm_backgroudColor{
    return JM_RGB_HEX(0xf2f2f2);
}

+(UIColor *)jm_themeColor{
    return JM_RGB_HEX(0xFFCA00);
}

+(UIColor *)jm_themeViewColor{
    return JM_RGB_HEX(0xF8D150);
}

+(UIColor *)jm_lineGrayColor{
    return JM_RGB_HEX(0xcccccc);
}

+(UIColor *)jm_lineLigthgrayColor{
    return JM_RGB_HEX(0xe9e9e9);
}

+(UIColor *)jm_textBlackColor{
    return JM_RGB_HEX(0x32343d);
}

+(UIColor *)jm_textGrayColor{
    return JM_RGB_HEX(0x777777);
}

+(UIColor *)jm_textLightgrayColor{
    return JM_RGB_HEX(0xaaaaaa);
}

+(UIColor *)jm_textLightblackColor{
    return JM_RGB(100, 100, 100, 1);
}

+(UIColor *)jm_greenColor{
    return JM_RGB_HEX(0x00a99d);
}
+(UIColor *)jm_333333{
    return JM_RGB_HEX(0x333333);
}
+(UIColor *)jm_f1f1f1{
    return JM_RGB_HEX(0xf1f1f1);
}
@end

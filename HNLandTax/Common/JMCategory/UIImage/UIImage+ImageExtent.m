//
//  UIImage+ImageExtent.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "UIImage+ImageExtent.h"
#import "UIImage+Save.h"
#import "JMDateFormat.h"
@implementation UIImage (ImageExtent)

- (UIImage *)imageByScalingToSize:(CGSize)targetSize{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) ==NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

//-(UIImage *)ld_waterMark{
//    UIImage *img = self;
//    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:LDLocationAddress];
//    location = location?:@"";
//    NSString *date = [self getDate];
//    int w = img.size.width;
//    int h = img.size.height;
//
//    float scale = w/SCREEN_W;
//
//    UIGraphicsBeginImageContext(img.size);
//
//    [img drawInRect:CGRectMake(0, 0, w, h)];
//
//    NSDictionary *attr = @{
//                           NSFontAttributeName: [UIFont boldSystemFontOfSize:13*scale],
//                           NSForegroundColorAttributeName : RGB(255, 255, 0, 0.7)
//                           };
//
//    CGFloat hight = 15*scale;
//    CGFloat wid1 = [MyFactory widthWithView:location font:13*scale hight:20] + 20;
//    CGFloat wid2 = [MyFactory widthWithView:date font:13*scale hight:20] + 25;
//
//    [location drawInRect:CGRectMake(w-wid1, h - 2*hight ,wid1 ,hight) withAttributes:attr];
//    [date drawInRect:CGRectMake(w-wid2, h -hight ,wid2 ,hight) withAttributes:attr];
//
//    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [aimg ld_saveToAlbums];
//    return aimg;
    
//}
-(NSString *)getDate{
    return  [JMDateFormat jm_dateWithTimestamp: [[NSDate date] timeIntervalSince1970]
                                  FormatString:JMDateFormatTypeTominutes
                                         Style:JMSeparatorCharStyleChinese];
}
@end

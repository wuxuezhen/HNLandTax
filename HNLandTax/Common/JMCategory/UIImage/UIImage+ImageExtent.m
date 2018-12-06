//
//  UIImage+ImageExtent.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "UIImage+ImageExtent.h"
#import "UIImage+Save.h"
#import "UIColor+JMColor.h"
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

- (UIImage *)jm_changeColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)navShadowImage{
    return [self imageWithColor:UIColor.jm_backgroudColor size:CGSizeMake(1, 0.5)];
}


+ (UIImage *)imageWithColor:(UIColor *)color{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context  = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <=0 || size.height <=0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithView:(UIView *)currView{
    if (!currView) return nil;
    
    UIGraphicsBeginImageContextWithOptions(currView.bounds.size, NO, [UIScreen mainScreen].scale);
    [currView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithView:(UIView *)currView fram:(CGRect)fram{
    if (!currView) return nil;
    
    UIGraphicsBeginImageContextWithOptions(currView.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    UIRectClip(fram);
    [currView.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(contextRef);
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform pTransform = CGAffineTransformIdentity;
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            pTransform = CGAffineTransformTranslate(pTransform, self.size.width, self.size.height);
            pTransform = CGAffineTransformRotate(pTransform, M_PI);
        }
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            pTransform = CGAffineTransformTranslate(pTransform, self.size.width, 0);
            pTransform = CGAffineTransformRotate(pTransform, M_PI_2);
        }
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            pTransform = CGAffineTransformTranslate(pTransform, 0, self.size.height);
            pTransform = CGAffineTransformRotate(pTransform, -M_PI_2);
        }
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        {
            pTransform = CGAffineTransformTranslate(pTransform, self.size.width, 0);
            pTransform = CGAffineTransformScale(pTransform, -1, 1);
        }
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            pTransform = CGAffineTransformTranslate(pTransform, self.size.height, 0);
            pTransform = CGAffineTransformScale(pTransform, -1, 1);
        }
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationRight:
        case UIImageOrientationLeft:
        case UIImageOrientationDown:
            break;
        default:
            break;
    }
    
    CGContextRef pCtx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(pCtx, pTransform);
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(pCtx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(pCtx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef pCgimage = CGBitmapContextCreateImage(pCtx);
    UIImage *pImage = [UIImage imageWithCGImage:pCgimage];
    CGContextRelease(pCtx);
    CGImageRelease(pCgimage);
    return pImage;
}


- (UIImage *)normalizedImage{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0 , self.size}];
    UIImage *pImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pImage;
}

@end

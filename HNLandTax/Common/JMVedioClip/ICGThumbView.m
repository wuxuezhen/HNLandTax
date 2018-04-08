//
//  ICGVideoTrimmerLeftOverlay.m
//  ICGVideoTrimmer
//
//  Created by Huong Do on 1/19/15.
//  Copyright (c) 2015 ichigo. All rights reserved.
//

#import "ICGThumbView.h"

@interface ICGThumbView()

@property (nonatomic) BOOL isRight;
@property (strong, nonatomic) UIImage *thumbImage;

@end

@implementation ICGThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(NO, nil);
    @throw nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color right:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        _isRight = flag;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame thumbImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbImage = image;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect relativeFrame = self.bounds;
//    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(0, -30, 0, -30);
//    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
//    return CGRectContainsPoint(hitFrame, point);
//}

- (void)drawRect:(CGRect)rect{
    // Drawing code
    
    if (self.thumbImage) {
        [self.thumbImage drawInRect:rect];
    } else {
        //// Frames
//        CGRect bubbleFrame = self.bounds;
//
//        //// Rounded Rectangle Drawing
//        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(bubbleFrame), CGRectGetMinY(bubbleFrame), CGRectGetWidth(bubbleFrame), CGRectGetHeight(bubbleFrame));
//        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(3, 3)];
//        if (self.isRight) {
//            roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(3, 3)];
//        }
//        [roundedRectanglePath closePath];
//        [self.color setFill];
//        [roundedRectanglePath fill];
//
//
//        CGRect decoratingRect = CGRectMake(CGRectGetMinX(bubbleFrame)+CGRectGetWidth(bubbleFrame)/2.5, CGRectGetMinY(bubbleFrame)+CGRectGetHeight(bubbleFrame)/4, 1.5, CGRectGetHeight(bubbleFrame)/2);
//        UIBezierPath *decoratingPath = [UIBezierPath bezierPathWithRoundedRect:decoratingRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii: CGSizeMake(1, 1)];
//        [decoratingPath closePath];
//        [[UIColor colorWithWhite:1 alpha:0.5] setFill];
//        [decoratingPath fill];
        
        CGContextRef context =UIGraphicsGetCurrentContext();
        // 设置线条的样式
        CGContextSetLineCap(context, kCGLineCapRound);
        // 绘制线的宽度
        CGContextSetLineWidth(context, 2.0);
        // 线的颜色
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        // 开始绘制
        CGContextBeginPath(context);
        // 设置虚线绘制起点
        CGContextMoveToPoint(context, 1, 1);
        // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
        CGFloat lengths[] = {5,5};
        // 虚线的起始点
        CGContextSetLineDash(context, 0, lengths, 2);
        // 绘制虚线的终点
        CGContextAddLineToPoint(context, 1 ,CGRectGetHeight(rect));
        // 绘制
        CGContextStrokePath(context);
        // 关闭图像
        CGContextClosePath(context);
        
        

    }
}


@end

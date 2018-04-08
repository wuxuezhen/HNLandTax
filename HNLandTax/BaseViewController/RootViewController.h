//
//  RootViewController.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@property (nonatomic, assign) BOOL banSlidingBack;

/**
是否隐藏nav下的白线
 */
-(BOOL)jm_hiddenNavShadowImage;


/**
 通过图片创建导航栏右边按钮，需重写ld_rightBarButtonItemAction:
 @param imageName 图片名称
 */
- (void)jm_createLeftBarButtonItemWithImage:(NSString *)imageName;
/**
 通过文字创建导航栏右边按钮,需重写ld_rightBarButtonItemAction:
 @param title 按钮名称
 */
- (void)jm_createLeftBarButtonItemWithTitle:(NSString *)title;
/**
 导航右边按钮的点击行为
 */
- (void)jm_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem;



/**
 通过图片创建导航栏右边按钮，需重写ld_rightBarButtonItemAction:
 @param imageName 图片名称
 */
- (void)jm_createRightBarButtonItemWithImage:(NSString *)imageName;

/**
 通过文字创建导航栏右边按钮,需重写ld_rightBarButtonItemAction:
 @param title 按钮名称
 */
- (void)jm_createRightBarButtonItemWithTitle:(NSString *)title;

/**
 导航右边按钮的点击行为
 */
- (void)jm_rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem;


/**
 image handle

 @param image 图片
 */
- (void)cameraOrAlbumObtainPhoto:(UIImage *)image;
- (void)photoToSave;

@end

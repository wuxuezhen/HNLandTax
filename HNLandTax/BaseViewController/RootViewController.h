//
//  RootViewController.h
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BarButtonItem.h"
@interface RootViewController : UIViewController
@property (nonatomic, assign) BOOL banSlidingBack;

/**
 image handle
 @param image 图片
 */
- (void)cameraOrAlbumObtainPhoto:(UIImage *)image;
- (void)photoToSave;

@end

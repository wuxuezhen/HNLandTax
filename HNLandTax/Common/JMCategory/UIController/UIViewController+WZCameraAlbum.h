//
//  UIViewController+WZCameraAlbum.h
//  HNLandTax
//
//  Created by wzz on 2018/11/25.
//  Copyright © 2018 WYW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^wz_getImageBlock)(UIImage *);

@interface UIViewController (WZCameraAlbum)

-(void)wz_getCameraAlbumImageBlock:(wz_getImageBlock)getImageBlock;

@end

NS_ASSUME_NONNULL_END

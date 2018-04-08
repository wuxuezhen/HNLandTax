//
//  RootViewController+ChoosePhoto.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/3.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "RootViewController+ChoosePhoto.h"
#import "UIViewController+AppSettings.h"
#import "UIViewController+Hud.h"
#import "JMTip.h"
#import "JMPhotosPermission.h"

@implementation RootViewController (ChoosePhoto)

#pragma mark - 添加图片


-(void)showSheetView{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *setAlert = [UIAlertAction actionWithTitle:@"拍照"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypeCamera];
                                                     }];
    
    UIAlertAction *PhoneAlert = [UIAlertAction actionWithTitle:@"从相册选择"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                       }];
    UIAlertAction *hidAlert = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:setAlert];
    [alert addAction:PhoneAlert];
    [alert addAction:hidAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)showSheetViewAndSave{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *setAlert = [UIAlertAction actionWithTitle:@"拍照"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypeCamera];
                                                     }];
    
    UIAlertAction *PhoneAlert = [UIAlertAction actionWithTitle:@"从相册选择"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                       }];
    UIAlertAction *hidAlert = [UIAlertAction actionWithTitle:@"保存照片"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self photoToSave];
                                                     }];
    [alert addAction:setAlert];
    [alert addAction:PhoneAlert];
    [alert addAction:hidAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma UIImagePickerControllerDelegate
//相册或则相机选择上传的实现
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self cameraOrAlbumObtainPhoto:image];
    }];
}



//选择照片
-(void)callCameraOrPhotoWithType:(UIImagePickerControllerSourceType)sourceType{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [JMPhotosPermission checkCameraPermission:^(BOOL permitted) {
            if (!permitted) {
                [self jm_showAlertWithTitle:@"请打开设置，允许使用相机"
                                    message:@"打开设置，开启相机权限"
                              confirmAction:^{
                                  [self jm_openAppSettings];
                              } cancelAction:^{
                                  
                              }];
                return ;
            }
            BOOL isCamera = YES;
            if (sourceType == UIImagePickerControllerSourceTypeCamera) {//判断是否有相机
                isCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
            }
            if (isCamera) {
                [self openCameraOrPhotoWithType:sourceType];
            } else {
                [JMTip showCenterWithText:@"请查看相机是否启用"];
            }
            
        }];
        
    }else{
        [JMPhotosPermission checkPhotoLibraryPermission:^(BOOL permitted) {
            if (!permitted) {
                [self jm_showAlertWithTitle:@"请打开设置，允许使用照片"
                                    message:@"打开设置，开始照片权限"
                              confirmAction:^{
                                  [self jm_openAppSettings];
                              } cancelAction:^{
                                  
                              }];
                return ;
            }
            [self openCameraOrPhotoWithType:sourceType];
            
        }];
    }
}

-(void)openCameraOrPhotoWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;//为NO，则不会出现系统的编辑界面
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

@end

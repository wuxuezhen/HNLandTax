//
//  JMPhotosPermission.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/7.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "JMPhotosPermission.h"
@import Photos;
@import AVFoundation;
@implementation JMPhotosPermission

+ (void)checkPhotoLibraryPermission:(void (^)(BOOL permitted))onPermittedBlock {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            if (onPermittedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    onPermittedBlock(YES);
                });
            }
            
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            if (onPermittedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    onPermittedBlock(NO);
                });
            }
            break;
            
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        if (onPermittedBlock) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                onPermittedBlock(YES);
                            });
                        }
                        break;
                    case PHAuthorizationStatusDenied:
                    case PHAuthorizationStatusRestricted:
                        if (onPermittedBlock) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                onPermittedBlock(NO);
                            });
                        }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

+ (void)checkCameraPermission:(void (^)(BOOL))onPermittedBlock {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onPermittedBlock ? onPermittedBlock(YES) : nil;
        });
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        dispatch_async(dispatch_get_main_queue(), ^{
            onPermittedBlock ? onPermittedBlock(NO) : nil;
        });
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onPermittedBlock ? onPermittedBlock(granted) : nil;
            });
            
        }];
    }
    
}
@end

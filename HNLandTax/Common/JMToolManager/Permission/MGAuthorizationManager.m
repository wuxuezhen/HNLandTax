//
//  MGAuthorizationManager.m
//  MiGuKit
//
//  Copyright © 2018 Migu Video Technology. All rights reserved.
//

#import "MGAuthorizationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import "NSObject+CurrentNav.h"

@implementation MGAuthorizationManager

+ (void)requestAuthorization:(MGAuthorizationType)type completionHandler:(void(^)(BOOL granted, BOOL isFirst))completionHandler {
    [self requestAuthorization:type showAlert:YES completionHandler:completionHandler];
}

+ (void)requestAuthorization:(MGAuthorizationType)type showAlert:(BOOL)showAlert completionHandler:(void(^)(BOOL granted, BOOL isFirst))completionHandler {
    switch (type) {
        case MGAuthorizationTypePhotoLibrary: {
            PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
            BOOL isFirst = (photoAuthorStatus == PHAuthorizationStatusNotDetermined);
            if (photoAuthorStatus == PHAuthorizationStatusDenied) {
                if (completionHandler) {
                    completionHandler(NO, isFirst);
                }
                if (showAlert) {
                    [self showAlert:@"访问相册"];
                }
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(status == PHAuthorizationStatusAuthorized, isFirst);
                        }
                    });
                }];
            }
        } break;
            
        case MGAuthorizationTypeCamera:
        case MGAuthorizationTypeMicrophone: {
            AVMediaType t = (type == MGAuthorizationTypeCamera ? AVMediaTypeVideo : AVMediaTypeAudio);
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:t];
            BOOL isFirst = (status == AVAuthorizationStatusNotDetermined);
            if (status == AVAuthorizationStatusDenied) {
                if (completionHandler) {
                    completionHandler(NO, isFirst);
                }
                if (showAlert) {
                    [self showAlert:(type == MGAuthorizationTypeCamera ? @"访问相机" : @"访问麦克风")];
                }
            } else {
                [AVCaptureDevice requestAccessForMediaType:t completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(granted, isFirst);
                        }
                    });
                }];
            }
        } break;
            
        case MGAuthorizationTypeContacts: {
            if (@available(iOS 9.0, *)) {
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                BOOL isFirst = (status == CNAuthorizationStatusNotDetermined);
                if (status == CNAuthorizationStatusDenied) {
                    if (completionHandler) {
                        completionHandler(NO, isFirst);
                    }
                    if (showAlert) {
                        [self showAlert:@"访问通讯录"];
                    }
                } else {
                    CNContactStore *contactStore = [[CNContactStore alloc] init];
                    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completionHandler) {
                                completionHandler(granted, isFirst);
                            }
                        });
                    }];
                }
            } else {
                ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
                BOOL isFirst = (status == kABAuthorizationStatusNotDetermined);
                if (status == kABAuthorizationStatusDenied) {
                    if (completionHandler) {
                        completionHandler(NO, isFirst);
                    }
                    if (showAlert) {
                        [self showAlert:@"访问通讯录"];
                    }
                } else {
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completionHandler) {
                                completionHandler(granted, isFirst);
                            }
                        });
                        CFRelease(addressBook);
                    });
                }
            }
        } break;
            
        case MGAuthorizationTypeCalendars:
        case MGAuthorizationTypeReminder: {
            EKEntityType t = (type == MGAuthorizationTypeCalendars ? EKEntityTypeEvent : EKEntityTypeReminder);
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:t];
            BOOL isFirst = (status == EKAuthorizationStatusNotDetermined);
            if (status == EKAuthorizationStatusDenied) {
                if (completionHandler) {
                    completionHandler(NO, isFirst);
                }
                if (showAlert) {
                    [self showAlert:(type == MGAuthorizationTypeCalendars ? @"访问日历" : @"访问备忘录")];
                }
            } else {
                EKEventStore *store = [[EKEventStore alloc] init];
                [store requestAccessToEntityType:t completion:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(granted, isFirst);
                        }
                    });
                }];
            }
        } break;
            
        default:
            break;
    }
}


+ (void)showAlert:(NSString *)string {
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    NSString *str = [NSString stringWithFormat:@"请在[设置]中允许%@%@", appName, string];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].currentNav presentViewController:alert animated:YES completion:nil];
}


@end

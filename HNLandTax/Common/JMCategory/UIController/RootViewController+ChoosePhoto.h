//
//  RootViewController+ChoosePhoto.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2018/1/3.
//  Copyright © 2018年 coreface. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController (ChoosePhoto)<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
-(void)showSheetView;
-(void)showSheetViewAndSave;
@end

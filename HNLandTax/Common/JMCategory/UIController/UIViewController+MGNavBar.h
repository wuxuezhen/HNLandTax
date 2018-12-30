//
//  UIViewController+MGNavBar.h
//  MiguVideo
//
//  Created by Alfred Zhang on 2018/4/26.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MGNavBar)

@property (nonatomic, strong, readonly) UIView *mgNavBar;
@property (nonatomic, copy) NSString *mgNavTitle;

@property (nonatomic, strong, readonly) UILabel *mgNavTitleLabel;
@property (nonatomic, strong, readonly) UIButton *mgNavBackBtn;
@property (nonatomic, copy) dispatch_block_t mgNavBackBlock;

- (void)mgShowNavBar;
- (void)mgHideNavBar;

- (void)mgShowNavBar:(NSString *)title;
- (void)mgShowNavBar:(NSString *)title backBlock:(dispatch_block_t)backBlock;

@end

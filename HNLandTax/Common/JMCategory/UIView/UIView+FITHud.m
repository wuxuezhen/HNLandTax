//
//  UIView+FITHud.m
//  FitBody
//
//  Created by caiyi on 2018/8/29.
//  Copyright © 2018年 caiyi. All rights reserved.
//

#import "UIView+FITHud.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "FITArcView.h"
@implementation UIView (FITHud)

- (void)fit_showProgressHud:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    FITArcView *arcview = [[FITArcView alloc]initWithFrame:CGRectZero];
    hud.customView = arcview;
    
    NSLayoutConstraint *w_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:37.f];
    NSLayoutConstraint *h_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:37.f];
    [hud.customView addConstraints:@[w_constraint,h_constraint]];
    hud.margin = 13.f;
    
    if (text) {
        hud.label.text = text;
    }
    
}


- (void)fit_showProgressHud {
    [self fit_showProgressHud:nil];
}


- (void)fit_dismissHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (MBProgressHUD *hud in [self HUDSForView]) {
            [hud hideAnimated:YES];
            hud.removeFromSuperViewOnHide = YES;
        }
    });
}

-(BOOL)fit_hudExist{
    return [self HUDSForView] > 0;
}


- (NSArray *)HUDSForView {
    NSEnumerator *subviewsEnum = [self.subviews reverseObjectEnumerator];
    NSMutableArray *huds = [NSMutableArray arrayWithCapacity:0];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:MBProgressHUD.class]) {
            [huds addObject:subview];
        }
    }
    return huds;
}
@end

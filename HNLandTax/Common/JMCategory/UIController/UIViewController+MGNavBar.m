//
//  UIViewController+MGNavBar.m
//  MiguVideo
//
//  Created by Alfred Zhang on 2018/4/26.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import "UIViewController+MGNavBar.h"
#import <objc/runtime.h>
#import "MGMacro.h"
#define MG_NAV_NAVIGATION_BAR_HEIGHT   44
#define MG_NAV_BAR_WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

@interface UIViewController ()
@property (nonatomic, strong, readwrite) UILabel *mgNavTitleLabel;
@property (nonatomic, strong, readwrite) UIButton *mgNavBackBtn;

@end

@implementation UIView (MGNavBar)

- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

@end

@implementation UIViewController (MGNavBar)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		
		SEL originalSelector = @selector(viewWillAppear:);
		SEL swizzledSelector = @selector(MGNavBar_viewWillAppear:);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
		
		BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
		if (success) {
			class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod);
		}
        
	});
}


- (void)MGNavBar_viewWillAppear:(BOOL)animated {
	if([self.navigationController.viewControllers containsObject:self]){
//			NSLog(@"========== %@",self);
//          NSLog(@"========== %@",self.navigationController);
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
	}
	
	[self MGNavBar_viewWillAppear:animated];
}

//- (void)mgNavViewWillLayoutSubviews {
//    if (self.mgNavBar.hidden) {
//        self.mgNavBar.frame = CGRectMake(0, 0,MG_NAV_BAR_WIDTH, 0);
//    }else {
//        CGFloat delta = (IS_HOTSPOT_CONNECTED?(iPhoneX?0:HOTSPOT_STATUSBAR_HEIGHT):0);
//        self.mgNavBar.frame = CGRectMake(0, 0,MG_NAV_BAR_WIDTH, STATUS_AND_NAV_BAR_HEIGHT - delta);
//        self.mgNavBackBtn.frame = CGRectMake(0, 0, MG_NAV_NAVIGATION_BAR_HEIGHT, MG_NAV_NAVIGATION_BAR_HEIGHT);
//        self.mgNavTitleLabel.frame = CGRectMake(0, 0, MG_NAV_BAR_WIDTH, MG_NAV_NAVIGATION_BAR_HEIGHT);
//        self.mgNavBackBtn.bottom = self.mgNavBar.bottom;
//        self.mgNavTitleLabel.bottom = self.mgNavBar.bottom;
//    }
//}

- (void)mgShowNavBar {
	
	CGFloat delta = (IS_HOTSPOT_CONNECTED?(iPhoneX?0:HOTSPOT_STATUSBAR_HEIGHT):0);
	
    self.mgNavBar.frame = CGRectMake(0, 0,MG_NAV_BAR_WIDTH, STATUS_AND_NAV_BAR_HEIGHT - delta);
    self.mgNavBackBtn.frame = CGRectMake(0, 0, MG_NAV_NAVIGATION_BAR_HEIGHT, MG_NAV_NAVIGATION_BAR_HEIGHT);
    self.mgNavTitleLabel.frame = CGRectMake(0, 0, MG_NAV_BAR_WIDTH, MG_NAV_NAVIGATION_BAR_HEIGHT);
	self.mgNavBackBtn.bottom = self.mgNavBar.bottom;
	self.mgNavTitleLabel.bottom = self.mgNavBar.bottom;
    self.mgNavBar.hidden = NO;
}


- (void)mgShowNavBar:(NSString *)title {
    [self mgShowNavBar];
    self.mgNavTitle = title;
}

- (void)mgShowNavBar:(NSString *)title backBlock:(dispatch_block_t)backBlock {
    [self mgShowNavBar:title];
    self.mgNavBackBlock = backBlock;
}

- (void)mgHideNavBar {
    self.mgNavBar.hidden = YES;
    self.mgNavBar.frame = CGRectMake(0, 0,MG_NAV_BAR_WIDTH, 0);
}

- (void)mgInNavBack {
    if (self.mgNavBackBlock) {
        self.mgNavBackBlock();
    }else {
//        [self.currentNav popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIImage *)mgInBackImage {
    NSString *image2 = @"iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAAEgBckRAAAAAXNSR0IArs4c6QAAAmhJREFUaAXtWUtOwzAQtVuOAWfojjuwoxISpNmjFonTIEHFvi2s4B4sKyT2cAxa49dmQhwSZ2znU6REKuPPzLx5E3viBCG4VxRN1R9d/iCZFlqwJkkplXF8c5l2qFE4SJOHIhGkNREUKFuRDCBZnrMG1PY2JAcHIIs4DMrigvJgMLgqmzfGocxeXU7Kk8n0Uxt8G3BVHRgcuFEVhX8+H0Wzc9w6G40j22TZHFbZdrt9EkIJKe3LU5Y5KRr/dSwE1v1icf9cpJcdYwH4OCYQKwByrNPwAmVuxOSYZOn2h8Jq9fCqxQZtnfMFpOtlZZB1luzXoR7brFZz9uJgAxCYK5AzgC8Q2fWyz4CZAVTSOJ6dmaNmz7qTTVWzh/2glDhWSj2aM2bPax+4bDZnABfn4OIE4OrcCcDHORvA1zkLIMR5JUCocwBU7QM8YPC4jCF9LisAnZhxRGEfiHNR7CLMjaXd9frtfTQ6/dC79QI/tDGWKjAaVgDYh4JUAoSCsABCQNgAviBOtQgguLJHSV3OxskBbT+Z+2tdpjndtItDLy1hKdVdOtE3+gz0GeggA151IjTOpM7ghW9XCKUUX8vl/MTHL/tFzsd53oYC14/fbAXfKCVv87rcfit3gALXQRmB46DC+RJhI9MogSYDJ1KNEGgj8EYItBl4rQS6CLwWAl0GHkwA3w7wek+OtNzUUVUy/lhNr/MoPCe1e/cVMkEa4msk7goLuSal4CrU9TIKJkCJ7IpIbQS6IlI7gbaJNEagLSKNE2iaSGsEbERC3ge8nwMUkKvE8Xn/DyU5RuD7n7x29dPr9xmoKQM/yJadGeRZ44AAAAAASUVORK5CYII=";
    NSString *image3 = @"iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAAEi6oPRAAAAAXNSR0IArs4c6QAAA7hJREFUeAHtm7ty1DAUhm1PuPTJkFBRJfssUEGZpKEkzOQBqLJU0O8MoaRJtoQKniVJRUXCJD23idl/zNnVemRZks+xpUU7A9bK0tG3n21Zkp0sE/3s7r4oDw8P7zU24l2gUEPmef7l5ubPRzVPm97bO/iMf9qdaqZ1QbWScBqujE14F1iSaWxC3dnaHBW2LkgVhtsCtQk3t8Giyhsbd+5PJpOfujrGQDYBdEGX8hDE6jz/V8tIhEBlWT7GVXZ6evxkqaXaF2MgKusSkOoYtwhI3owF006tAaujhproy6+vf//IsvxyOj1+WI9mFWgRJMum0/faOtpMtTWbIChvDGQbxBjIJUhjINcgCKTttauj0ywWFa0/uKbYrqsUzNr7vGDl7ODbPCMlojZg7I26/DK1/yiK4u3JybtXNvHWbAq5lCGQWT80r7a9/eBo/qUlwWaIQNT2TIMytZya7gzEBUJQ3kDcIN5AUiBeQPX7m885Qg03bbV36qbCGGar+6wmtmoFi7TXOUTDdopvMx+gsm1bLyAKKgHWCUgCjAWIE4wVqAnM5V7mdJVRg21bTHgxSQEIZj0u97K22Gl/MpAMrJwBkY4RltT7XNPCic6mSMeowugaNeWxA9Vh6mMoEwz2sR4yHUzbumkdkA2IA4bNEBcMCxAnTGcgbphOQBIw3kBSMF5AkjDOQNIwALLuqff3X77BQyJUwodzclhFrP63Brq9LZ+rFdfX156p37nS1kCj0eYjtVGs1GMlRM3jSDvdOqSXYvCDnIBQQRrKGUgaygtIEsobSAqqE5AEVGcgbigWIE4oNiAuKOueGg22ffBuB5aK1XL07FXNM6VZgdCQDsoEUN/HDkRQo9HW7D6XX1araPVm0/dkIBlIBpKBZGA1DbCOhfpSNB6P715cfH9NM+miyD/g8dcs/xc3Q1SCMD/FU3l1vWMhRP9m5GK/X4r9RR0/DHMtEjMbCM8Xguo1cBbV8zi+B30GkRj9GVP9fKyYYZGq6a3xrpKCFBSCGBIblKCQxAQlKEQxQQgKWcyggmIQM4igmMT0KihGMb0IilmMqCDMlc7Prz4NOcCjH9h1KzLVODu7+ppl5ZYOTnrkq2uzS57IMrlpXoSzChNOXH5dwPuqKzaSXoX+BwdBTBAd4dhFiQuKXVRvgmIV1bug2EQNJigWUYMLCl1UMIJCFRWcoNBEBSvIVdTOzubT//q5WPuAU+a5mMhcjI4+5xaPdfBXIHhpTPfnKab5HydHipUMJAPJQDIQkIG/Ipfsq+yXd94AAAAASUVORK5CYII=";
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[UIScreen mainScreen].scale>=3?image3:image2 options:NSDataBase64DecodingIgnoreUnknownCharacters] scale:[UIScreen mainScreen].scale];
}

#pragma mark- Getter & Setter

- (void)setMgNavTitle:(NSString *)mgNavTitle {
    self.mgNavTitleLabel.text = mgNavTitle;
}

- (NSString *)mgNavTitle {
    return self.mgNavTitleLabel.text;
}

- (dispatch_block_t)mgNavBackBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMgNavBackBlock:(dispatch_block_t)mgNavBackBlock {
    objc_setAssociatedObject(self, @selector(mgNavBackBlock), mgNavBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UILabel *)mgNavTitleLabel {
    UILabel *view = objc_getAssociatedObject(self, _cmd);
    if (view == nil) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        view = titleLabel;
        self.mgNavTitleLabel = view;
    }
    return view;
}

- (void)setMgNavTitleLabel:(UILabel *)mgNavTitleLabel {
    objc_setAssociatedObject(self, @selector(mgNavTitleLabel), mgNavTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)mgNavBackBtn {
    UIButton *btn = objc_getAssociatedObject(self, _cmd);
    if (btn == nil) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [view setImage:[self mgInBackImage] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(mgInNavBack) forControlEvents:UIControlEventTouchUpInside];
        btn = view;
        self.mgNavBackBtn = view;
    }
    return btn;
}

- (void)setMgNavBackBtn:(UIButton *)mgNavBackBtn {
    objc_setAssociatedObject(self, @selector(mgNavBackBtn), mgNavBackBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)mgNavBar {
    UIView *nav = objc_getAssociatedObject(self, _cmd);
    if (nav == nil) {
        nav = [UIView new];
        nav.backgroundColor = [UIColor whiteColor];
        nav.clipsToBounds = YES;
        [nav addSubview:self.mgNavBackBtn];
        [nav addSubview:self.mgNavTitleLabel];
        nav.hidden = YES;
        nav.frame = CGRectMake(0, 0,MG_NAV_BAR_WIDTH, 0);
        [self.view addSubview:nav];
        self.mgNavBar = nav;
    }
    return nav;
}

- (void)setMgNavBar:(UIView *)mgNavBar {
    objc_setAssociatedObject(self, @selector(mgNavBar), mgNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//
//  JMWebViewController.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/16.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMWebViewController.h"
#import "UIViewController+Hud.h"
#import "JMTip.h"
#import <WebKit/WebKit.h>
#import "JMWeiDu.h"

static NSString *leftImage = @"WD_NavgationBack_Normal1";

@interface JMWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation JMWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self jm_createLeftBarButtonItemWithImage:leftImage];
    [self loadWebView:self.url];
    [self createProgressView];
}

#pragma mark - load Web
-(void)loadWebView:(NSString *)url{
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    [self.webView setAllowsBackForwardNavigationGestures:YES];
    NSURL *webUrl = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
    //加载一个网页
    [self.webView loadRequest:request];
}

-(void)jm_leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem{
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

#pragma mark - 创建 UIProgressView
-(void)createProgressView{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 2)];
    self.progressView.trackTintColor = [UIColor whiteColor];
    self.progressView.progressTintColor = JM_RGB_HEX(0x00BFFF);
    self.progressView.progress = 0.1;
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(@2);
    }];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 weakSelf.progressView.hidden = YES;
                                 
                             }];
        }
    }else{
        
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        
    }
}

#pragma mark - web周期
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *lJs2 = @"document.title";
    [webView evaluateJavaScript:lJs2
              completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                  if (error) {
                      NSLog(@"JSError:%@",error);
                  }else{
                      self.title = htmlStr;
                  }
              }] ;
    self.progressView.hidden = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [JMTip showCenterWithText:@"页面找不到了"];
    self.progressView.hidden = YES;
}

#pragma mark - 捕获弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [self jm_showAlertWithTitle:@"提示"
                        message:message?:@""
                    actionTitle:@"好的"
                  confirmAction:^{
                      completionHandler();
                  }];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    [self jm_showAlertWithTitle:@"提示"
                        message:message?:@""
         destructiveActionTitle:@"确认"
              cancelActionTitle:@"取消"
                  confirmAction:^{
                      completionHandler(YES);
                  } cancelAction:^{
                      completionHandler(NO);
                  }];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           completionHandler(alertController.textFields[0].text?:@"");
                                                       }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

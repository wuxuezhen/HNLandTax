//
//  LDWebViewViewController.m
//  TuoDian
//
//  Created by rifei wang on 2017/6/21.
//  Copyright © 2017年 wxz. All rights reserved.
//

#import "LDWebViewViewController.h"
#import<WebKit/WebKit.h>


@interface LDWebViewViewController ()

@end

@implementation LDWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(private_actionShare)];
    self.navigationItem.rightBarButtonItem = item;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL fileURLWithPath:self.stringURL];
    NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    [webView loadFileURL:url allowingReadAccessToURL:path];
    [self.view addSubview:webView];
}

#pragma mark - private
- (void)private_actionShare{    
    NSArray *activityItems = @[[NSURL fileURLWithPath:self.stringURL]];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    __weak typeof(self) this = self;
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed) {
            
        }
    }];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
}

    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AddDataViewController.m
//  HNLandTax
//
//  Created by wzz on 2018/12/10.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "AddDataViewController.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import "JMCoreDataManager.h"
#import "WZVideo.h"
#import "JMWeiDu.h"
@interface AddDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *urlText;
@property (weak, nonatomic) IBOutlet UIButton *makesureBtn;

@end

@implementation AddDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频信息";
    self.urlText.placeholder = @"请输入视频URL,添加到播放列表";
    self.urlText.layer.borderColor  = JM_RGB_HEX(0xf5f5f5).CGColor;
    self.urlText.layer.borderWidth  = 0.5;
    self.urlText.layer.cornerRadius = 5;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)confirm:(id)sender {
    [self.view endEditing:YES];
    
    NSString *name = self.nameField.text;
    NSString *url  = self.urlText.text;
    if (url.length > 0) {
        WZVideo *video = [[WZVideo alloc]init];
        video.name     = name;
        video.videoUrl = url;
        [[JMCoreDataManager manager] addData:video];
        self.addVideoSuccess ? self.addVideoSuccess() : nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
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

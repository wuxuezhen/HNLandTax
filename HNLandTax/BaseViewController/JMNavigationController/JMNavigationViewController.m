//
//  JMNavigationViewController.m
//  WeiDu
//
//  Created by 吴振振 on 2017/11/24.
//  Copyright © 2017年 吴振振. All rights reserved.
//

#import "JMNavigationViewController.h"
#import "UIColor+JMColor.h"
@interface JMNavigationViewController ()

@end

@implementation JMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
//        self.navigationBar.tintColor = [UIColor blackColor];
//        self.navigationBar.barTintColor = [UIColor jm_themeColor];
    }
    return self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
   if (self.childViewControllers.count > 0){
       viewController.hidesBottomBarWhenPushed = YES;
//       UIImage *image = [UIImage imageNamed:@"WD_NavgationBack_Normal1"];
//       viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image
//                                                                                         style:UIBarButtonItemStylePlain
//                                                                                        target:self
//                                                                                        action:@selector(jm_back)];
   }
    [super pushViewController:viewController animated:animated];
}

-(void)jm_back{
    [self popViewControllerAnimated:YES];
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

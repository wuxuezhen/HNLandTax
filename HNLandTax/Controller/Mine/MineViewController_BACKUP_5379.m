//
//  MineViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    
    self.locations = [NSMutableArray arrayWithCapacity:0];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView .delegate = self;
    self.mapView .showsCompass = YES;
    self.mapView .showsScale = YES;
    self.mapView .mapType = MAMapTypeStandard;
    [self.mapView setZoomLevel:15 animated:YES];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
    represent.showsAccuracyRing = NO;
    represent.showsHeadingIndicator = YES;
    represent.enablePulseAnnimation = YES;
//    represent.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
//    represent.strokeColor = [UIColor lightGrayColor];
//    represent.lineWidth = 2.f;
    represent.image = [UIImage imageNamed:@"userPosition"];
    [self.mapView updateUserLocationRepresentation:represent];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.label];
=======
>>>>>>> aa1421cb20bedfbc6dec33e727142a2c098de905
    // Do any additional setup after loading the view.
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

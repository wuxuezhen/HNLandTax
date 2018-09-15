//
//  MineViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "MineViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "JMWeiDu.h"
@interface MineViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) MAPointAnnotation *centerPoint;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic, strong) UILabel *label;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view.
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (self.centerPoint == nil) {
        self.centerPoint = [[MAPointAnnotation alloc]init];
    }
    
    if (self.lastLocation) {
        CLLocation *location = userLocation.location;
        CLLocationDistance distance = [location distanceFromLocation:self.lastLocation];
        if (distance > 3) {
            self.label.text =  @((NSInteger)distance).stringValue;
            [self.locations addObject:location];
            self.lastLocation = userLocation.location;
            [self addLayer:self.locations];
        }
    }else{
        self.lastLocation = userLocation.location;
        [self.locations addObject:self.lastLocation];
    }

    
//    if (!updatingLocation){
//        MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
//        [UIView animateWithDuration:0.1 animations:^{
//            double degree = userLocation.heading.trueHeading - mapView.rotationDegree;
//            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
//        }];
//    }
}
-(void)addLayer:(NSArray *)arr{
    CLLocationCoordinate2D coords[arr.count];
    for (NSInteger i = 0; i < arr.count; i ++ ) {
        CLLocation *location = arr[i];
        coords[i].latitude = location.coordinate.latitude;
        coords[i].longitude = location.coordinate.longitude;
    }
    if (self.polyline) {
        [self.polyline setPolylineWithCoordinates:coords count:arr.count];
    }else{
        self.polyline = [MAPolyline polylineWithCoordinates:coords count:arr.count];
        [self.mapView addOverlay: self.polyline];
    }
 
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 2.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.5];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

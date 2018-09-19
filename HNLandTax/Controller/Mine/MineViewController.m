//
//  MineViewController.m
//  HNLandTax
//
//  Created by 吴振振 on 2018/4/4.
//  Copyright © 2018年 WYW. All rights reserved.
//

#import "MineViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MATraceManager.h>
#import "JMWeiDu.h"
@interface MineViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) MAPointAnnotation *centerPoint;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger totalDistance;
@property (nonatomic, strong) MATraceManager *manager;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locations = [NSMutableArray arrayWithCapacity:0];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.distanceFilter = 8;
    self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
    self.mapView.delegate = self;
    self.mapView.showsCompass = YES;
    self.mapView.showsScale = YES;
    self.mapView.mapType = MAMapTypeStandard;
    [self.mapView setZoomLevel:15 animated:YES];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
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
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.5];
    self.button.layer.cornerRadius = 15;
    [self.button addTarget:self action:@selector(returnMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    // Do any additional setup after loading the view.
}
-(void)returnMyLocation{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (self.centerPoint == nil) {
        self.centerPoint = [[MAPointAnnotation alloc]init];
    }
    
    if (self.lastLocation) {
        CLLocation *location = userLocation.location;
        
        double distance = [self distanceWithUserLocation:location lastLocation:self.lastLocation];
//        CLLocationDistance distance = [location distanceFromLocation:self.lastLocation];
        //传感器活动状态
        if (distance > 3 && [self isRecordWithLocation:location]) {
            self.totalDistance = self.totalDistance + (NSInteger)distance;
            self.label.text =  @(self.totalDistance).stringValue;
            [self.locations addObject:location];
            self.lastLocation = userLocation.location;
            [self queryTraceWithLocations:self.locations];
        }

    }else{
        self.totalDistance = 0;
        if (userLocation.location && [self isRecordWithLocation:userLocation.location]) {
            self.lastLocation = userLocation.location;
            [self.locations addObject:self.lastLocation];
        }
    }

    
//    if (!updatingLocation){
//        MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
//        [UIView animateWithDuration:0.1 animations:^{
//            double degree = userLocation.heading.trueHeading - mapView.rotationDegree;
//            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
//        }];
//    }
}
-(BOOL)isRecordWithLocation:(CLLocation *)location{
    if (location.horizontalAccuracy < 40 && location.horizontalAccuracy > 0){
        return YES;
    }else{
        return NO;
    }
}

-(double)distanceWithUserLocation:(CLLocation *)userLocation lastLocation:(CLLocation *)lastLocation{
    MAMapPoint point1 = MAMapPointForCoordinate(userLocation.coordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(lastLocation.coordinate);
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}

#pragma mark -------------------- 轨迹纠偏 --------------------
- (void)queryTraceWithLocations:(NSArray<CLLocation *> *)locations{
    NSMutableArray *mArr = [NSMutableArray array];
    for(CLLocation *loc in locations){
        MATraceLocation *tLoc = [[MATraceLocation alloc] init];
        tLoc.loc = loc.coordinate;
        tLoc.speed = loc.speed * 3.6; //m/s  转 km/h
        tLoc.time = [loc.timestamp timeIntervalSince1970] * 1000;
        tLoc.angle = loc.course;
        [mArr addObject:tLoc];
    }
    __weak typeof(self) weakSelf = self;
    __unused NSOperation *op = [self.manager queryProcessedTraceWith:mArr
                                                                type:-1
                                                  processingCallback:nil
                                                      finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
                                                          [weakSelf makePolylineWith:points];
                                                      } failedCallback:^(int errorCode, NSString *errorDesc) {
                                                          NSLog(@"Error: %@", errorDesc);
                                                      }];
    
}



- (void)makePolylineWith:(NSArray<MATracePoint*> *)tracePoints{
    if(tracePoints.count < 2){
        return ;
    }
    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * tracePoints.count);
    if(!pCoords) {
        return ;
    }
    
//    CLLocationCoordinate2D coords[tracePoints.count];
//    for (NSInteger i = 0; i < tracePoints.count; i ++ ) {
//        MATracePoint *p = tracePoints[i];
//        coords[i].latitude = p.latitude;
//        coords[i].longitude = p.longitude;
//    }
//
    for(int i = 0; i < tracePoints.count; ++i) {
        MATracePoint *p = [tracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
        pCur->latitude = p.latitude;
        pCur->longitude = p.longitude;
    }
    
    if (self.polyline) {
        [self.polyline setPolylineWithCoordinates:pCoords count:tracePoints.count];
    }else{
        self.polyline = [MAPolyline polylineWithCoordinates:pCoords count:tracePoints.count];
        [self.mapView setVisibleMapRect:[self.polyline boundingMapRect]];
        [self.mapView addOverlay: self.polyline];
    }
    
    if(pCoords){
        free(pCoords);
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.5];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

-(MATraceManager *)manager{
    if (!_manager) {
        _manager = [MATraceManager sharedInstance];
    }
    return _manager;
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

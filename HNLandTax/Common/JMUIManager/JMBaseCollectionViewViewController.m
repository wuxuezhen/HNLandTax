//
//  JMBaseCollectionViewViewController.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/12.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "JMBaseCollectionViewViewController.h"
@interface JMBaseCollectionViewViewController ()

@end

@implementation JMBaseCollectionViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view.
}

#pragma mark - MJRefresh

- (void)mj_refresh {
    [self mj_headerRefresh];
    [self mj_footerRefresh];
}

-(void)mj_headerRefresh{
    [self.collectionView jm_headerRefreshTarget:self selecter:@selector(mj_headerRefreshAction)];
}

-(void)mj_footerRefresh{
    [self.collectionView jm_footerRefreshTarget:self selecter:@selector(mj_footerRefreshAction)];
}

-(void)mj_headerRefreshAction{
    
}
-(void)mj_footerRefreshAction{
    
}
-(void)jm_startLoadData{
    [self.collectionView.mj_header beginRefreshing];
}
-(void)jm_CollectionViewDefault{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}
#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [UICollectionViewCell new];
}


#pragma mark - UICollectionViewDelegateFlowLayout

-(UICollectionViewScrollDirection)scrollDirection{
    return UICollectionViewScrollDirectionVertical;
}
-(CGFloat)minimumInteritemSpacing{
    return 0;
}
-(CGFloat)minimumLineSpacing{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

#pragma mark - 懒加载

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate  = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = [self scrollDirection];
        _layout.minimumInteritemSpacing = [self minimumInteritemSpacing];
        _layout.minimumLineSpacing = [self minimumLineSpacing];
    }
    return _layout;
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

//
//  JMBaseCollectionViewViewController.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/12.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "RootViewController.h"
#import "JMWeiDu.h"
@interface JMBaseCollectionViewViewController : RootViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)mj_refresh;
-(void)mj_headerRefresh;
-(void)mj_footerRefresh;
-(void)mj_headerRefreshAction;
-(void)mj_footerRefreshAction;

-(void)jm_startLoadData;
-(void)jm_CollectionViewDefault;

-(UICollectionViewScrollDirection)scrollDirection;
-(CGFloat)minimumInteritemSpacing;
-(CGFloat)minimumLineSpacing;

@end

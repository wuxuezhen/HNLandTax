//
//  BDScrollMenuView.m
//  BusinessDataPlatform
//
//  Created by 吴振振 on 2019/8/7.
//  Copyright © 2019 donghui lv. All rights reserved.
//

#import "BDScrollMenuView.h"
#import "BDScrollMenuItemCell.h"

#define BDScaleValue(a) a * [UIScreen mainScreen].bounds.size.width / 375.f

#define LINE_Width BDScaleValue(16)
#define MINItemSpacing BDScaleValue(25)

@implementation JKScrollMenuConfiguration

+ (JKScrollMenuConfiguration *)defaultScrollMenuConfiguration {
    JKScrollMenuConfiguration  *configuration = [JKScrollMenuConfiguration new];
    configuration.normalItemFont  = [UIFont systemFontOfSize:14];
    configuration.selectItemFont  = [UIFont boldSystemFontOfSize:14];
    configuration.normalItemColor = [UIColor blackColor];
    configuration.selectItemColor = [UIColor blueColor];
    configuration.lineViewSize    = CGSizeMake(16, 3);
    configuration.sectionInset         = UIEdgeInsetsMake(0, 16, 0, 16);
    configuration.lineViewCornerRadius = 1;
    configuration.minItemSpacing       = 20;
    configuration.lineViewColor        = [UIColor redColor];
    configuration.normalItemFont       = [UIFont systemFontOfSize:14];
    configuration.scrollEnabled        = YES;
    return configuration;
}


@end

@interface BDScrollMenuView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) JKScrollMenuConfiguration *configuration;

@property (nonatomic, strong) NSMutableArray *widths;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat viewWidth;

@end
@implementation BDScrollMenuView

-(instancetype)initWithFrame:(CGRect)frame
           menuConfiguration:(JKScrollMenuConfiguration *)configuration{
    if (self = [super initWithFrame:frame]) {
        _itemHeight     = self.frame.size.height;
        _viewWidth      = self.frame.size.width;
        _configuration = configuration;
        self.lineView.hidden = !configuration.showLineView;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollView];
}

-(void)initializedConfig{
    if (!self.titles || self.titles.count == 0) {
        return;
    }
    if (_configuration.scrollEnabled) {
        _widths     = [NSMutableArray arrayWithCapacity:0];
        for (NSString *title in self.titles) {
            [_widths addObject:@(title.length * BDScaleValue(14))];
        }
    }else{
        if (self.titles.count > 0) {
            _itemWidth = _viewWidth/self.titles.count;
        }else{
            _itemWidth = _viewWidth;
        }
    }
}
- (void)bd_refreshMenu{
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self bd_setLineLocation];
}

-(void)bd_setLineLocation{
    bd_async_mainQueue(^{
        self.scrollView.contentSize = self.collectionView.contentSize;
        NSLog(@"%lf",self.collectionView.contentSize.width);
        [self locationLineView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    });
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self initializedConfig];
    [self bd_refreshMenu];
}

#pragma mark - collectionViewDetegate && UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BDScrollMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(BDScrollMenuItemCell.class)
                                                                           forIndexPath:indexPath];
    if (self.selectItem == indexPath.item) {
        cell.titleColor = self.configuration.selectItemColor;
        cell.titleFont  = self.configuration.selectItemFont;
    }else{
        cell.titleColor = self.configuration.normalItemColor;
        cell.titleFont  = self.configuration.normalItemFont;
    }
    cell.title          = [self.titles objectAtIndex:indexPath.item];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.configuration.scrollEnabled) {
        CGFloat item_w = [[self.widths objectAtIndex:indexPath.item] floatValue];
        return CGSizeMake(item_w, _itemHeight);
    }else{
        return CGSizeMake(_itemWidth, _itemHeight);
    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.configuration.sectionInset;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItem != indexPath.item) {
        self.selectItem = indexPath.item;
    }
}

-(void)setSelectItem:(NSInteger)selectItem{
    _selectItem = selectItem;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectItem inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self locationLineView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }];
    
    bd_async_mainQueue(^{
        [self.collectionView reloadData];
        self.bd_selectBlock ? self.bd_selectBlock(selectItem, self.titles[selectItem]) : nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(bd_scrollMenuSelectItem:title:)]) {
            [self.delegate bd_scrollMenuSelectItem:selectItem title:self.titles[selectItem]];
        }
    });
    
}

-(void)locationLineView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BDScrollMenuItemCell *cell = (BDScrollMenuItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [collectionView convertRect:cell.frame toView:collectionView];
    CGFloat x = rect.origin.x + rect.size.width/2;
    CGPoint center = self.lineView.center;
    center.x = x;
    self.lineView.center = center;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.scrollView.contentOffset = self.collectionView.contentOffset;
}

#pragma mark - 懒加载

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = MINItemSpacing;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate  = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:BDScrollMenuItemCell.class forCellWithReuseIdentifier:@"BDScrollMenuItemCell"];
        
    }
    return _collectionView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _itemHeight - self.configuration.lineViewSize.height, _viewWidth, self.configuration.lineViewSize.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView addSubview:self.lineView];
    }
    return _scrollView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.configuration.lineViewSize.width, self.configuration.lineViewSize.height)];
        _lineView.backgroundColor = self.configuration.lineViewColor;
        _lineView.layer.cornerRadius = self.configuration.lineViewCornerRadius;
    }
    return _lineView;
}

void bd_async_mainQueue(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}


@end

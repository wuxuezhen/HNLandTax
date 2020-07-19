//
//  BDScrollMenuView.h
//  BusinessDataPlatform
//
//  Created by 吴振振 on 2019/8/7.
//  Copyright © 2019 donghui lv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKScrollMenuConfiguration : NSObject

@property (nonatomic, strong) UIFont *normalItemFont;
@property (nonatomic, strong) UIFont *selectItemFont;
@property (nonatomic, strong) UIColor *normalItemColor;
@property (nonatomic, strong) UIColor *selectItemColor;
@property (nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL showLineView;
@property (nonatomic) CGFloat minItemSpacing;
@property (nonatomic) CGSize  lineViewSize;
@property (nonatomic) CGFloat lineViewCornerRadius;
@property (nonatomic, strong) UIColor *lineViewColor;

+ (JKScrollMenuConfiguration *)defaultScrollMenuConfiguration;

@end


@class BDScrollMenuView;
@protocol BDScrollMenuViewDelegate <NSObject>

-(void)bd_scrollMenuSelectItem:(NSInteger)selectItem title:(NSString *)title;

@end

@interface BDScrollMenuView : UIView

@property (nonatomic, copy)   NSArray *titles;
@property (nonatomic, assign) NSInteger selectItem;

@property (nonatomic, copy) void (^bd_selectBlock) (NSInteger item, NSString *title);

@property (nonatomic , weak) id<BDScrollMenuViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame
           menuConfiguration:(JKScrollMenuConfiguration *)configuration;

-(void)bd_refreshMenu;

@end

NS_ASSUME_NONNULL_END

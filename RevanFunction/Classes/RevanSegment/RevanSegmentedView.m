//
//  RevanSegmentedView.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2017/12/25.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import "RevanSegmentedView.h"
#import "UIView+RevanSegmented.h"
#import "RevanSegmentConfig.h"


#define RevanScreenWidth [UIScreen mainScreen].bounds.size.width
#define RevanScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat minSpace = 30;

@interface RevanSegmentedView () {
    UIButton *_lastSeletBtn;
}

/** 内容ScrollView */
@property (nonatomic, strong) UIScrollView *segmentContentScrollView;
/** indicatorView指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** item数组 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemButtons;
/** 红色标识数组 */
@property (nonatomic, strong) NSMutableArray <UIView *>*markViews;
/** 配置信息 */
@property (nonatomic, strong) RevanSegmentConfig *segmentConfig;
/** segment上分割线 */
@property (nonatomic, strong) UIView *segmentTopLine;
/** segment下分割线 */
@property (nonatomic, strong) UIView *segmentBottomLine;

@end

@implementation RevanSegmentedView

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)updateSegmentConfig:(void(^)(RevanSegmentConfig *segmentConfig)) configBlock {
    if (configBlock) {
        configBlock(self.segmentConfig);
    }
    // 按照当前的  进行刷新
    self.backgroundColor = self.segmentConfig.backgroundColor;
    
    for (UIButton *btn in self.itemButtons) {
        [btn setTitleColor:self.segmentConfig.itemnormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.itemselectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.segmentConfig.itemfont;
    }
    
    // 指示器
    self.indicatorView.backgroundColor = self.segmentConfig.indicatorColor;
    // segment上下分割线
    self.segmentTopLine.frame = self.segmentConfig.segmentTopLine_frame;
    self.segmentTopLine.backgroundColor = self.segmentConfig.segmentTopLine_color;
    
    self.segmentBottomLine.frame = self.segmentConfig.segmentBottomLine_frame;
    self.segmentBottomLine.backgroundColor = self.segmentConfig.segmentBottomLine_color;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


/**
 segment Tab是否显示 角标
 
 @param index tab 索引
 @param isShow 是否显示
 */
- (void)segmentTabIndex:(NSInteger)index showMark:(BOOL)isShow {
    //过滤
    if (self.markViews.count == 0 || index < 0 || index > self.markViews.count - 1) {
        return;
    }
    UIView *markV = self.markViews[index];
    markV.hidden = !isShow;
}


+ (instancetype)instanceSegment {
    RevanSegmentedView *segmentedView = [[RevanSegmentedView alloc] init];
    return segmentedView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.segmentConfig.backgroundColor;
        [self setupUI];
    }
    return self;
}

/** 初始化 */
- (void)setupUI {
    //内容ScrollView
    [self addSubview:self.segmentContentScrollView];
    //segment上分割线
    [self addSubview:self.segmentTopLine];
    //segment下分割线
    [self addSubview:self.segmentBottomLine];
}

#pragma mark - 子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    //内容ScrollView
    self.segmentContentScrollView.frame = self.bounds;
    self.segmentContentScrollView.showsVerticalScrollIndicator = NO;
    self.segmentContentScrollView.showsHorizontalScrollIndicator = NO;
    self.segmentContentScrollView.pagingEnabled = YES;
    //segment上分割线
    self.segmentTopLine.frame = self.segmentConfig.segmentTopLine_frame;
    //segment下分割线
    self.segmentBottomLine.frame = self.segmentConfig.segmentBottomLine_frame;
    
    //按钮布局
    [self layoutItemButtons];
    //角标布局
    [self layoutMarkViews];
    //标志器布局
    if (self.itemButtons.count < 2) {
        //单个标题没有标识器
        return;
    }
    UIButton *selectBtn = nil;
    selectBtn = self.itemButtons[self.selectIndex];
    CGFloat indicatorH = self.segmentConfig.indicatorHeight;
    self.indicatorView.height = indicatorH;
    self.indicatorView.width = selectBtn.width + self.segmentConfig.indicatorExtensionWidth * 2;
    self.indicatorView.centerX = selectBtn.centerX;
    self.indicatorView.y = self.height - indicatorH - self.segmentConfig.indicatorbottomMargin;
//    self.selectIndex = self.selectIndex;
}

/** 按钮布局 */
- (void)layoutItemButtons {
    //标题布局
    CGFloat totalBtnWith = 0.0;
    for (UIButton *btn in self.itemButtons) {
        [btn sizeToFit];
        totalBtnWith += btn.width;
    }
    //间距
    CGFloat btnSpace = (self.segmentContentScrollView.width - totalBtnWith) / (self.itemButtons.count + 1);
    if (minSpace > btnSpace) {
        btnSpace = minSpace;
    }
    
    CGFloat btnX = btnSpace;
    CGFloat btnY = 0;
    CGFloat btnH = self.segmentConfig.itemheight;
    for (UIButton *btn in self.itemButtons) {
        [btn sizeToFit];
        CGFloat btnW = btn.width;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btnX += (btnW + btnSpace);
    }
    CGFloat contentSize = MIN(RevanScreenWidth, self.width);
    if (btnX < contentSize) {
        btnX = contentSize;
    }
    self.segmentContentScrollView.contentSize = CGSizeMake(btnX, 0);
}

/**
 角标布局
 */
- (void)layoutMarkViews {
    //角标布局
    NSInteger count = self.itemButtons.count;
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *btn = self.itemButtons[i];
        UIView *markV = self.markViews[i];
        markV.frame = CGRectMake(btn.right, self.segmentConfig.marktopMargin, self.segmentConfig.markradius * 2, self.segmentConfig.markradius * 2);
        //切圆
        CGFloat markRadius = self.segmentConfig.markradius;
        markV.backgroundColor = self.segmentConfig.markcolor;
        markV.layer.cornerRadius = markRadius;
    }
    
}

#pragma mark - 私有方法
- (void)onButtonClick:(UIButton *)btn {
    if (_lastSeletBtn != nil && _lastSeletBtn.tag == btn.tag) {
        return;
    }
    //代理
    if ([self.delegate respondsToSelector:@selector(revan_segmentedView:didSelectButton:disButton:)]) {
        [self.delegate revan_segmentedView:self didSelectButton:btn disButton:_lastSeletBtn];
    }
    
    _selectIndex = btn.tag;
    
    _lastSeletBtn.selected = NO;
    btn.selected = YES;
    _lastSeletBtn = btn;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.width = btn.width + self.segmentConfig.indicatorExtensionWidth * 2;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    CGFloat offsetX = btn.centerX - self.width * 0.5;
    //滚动左侧界限
    if (offsetX < 0) {
        offsetX = 0;
    }
    //滚动右侧界限
    CGFloat offsetRight = self.segmentContentScrollView.contentSize.width - self.width;
    if (offsetX > offsetRight) {
        offsetX = offsetRight;
    }
    [self.segmentContentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - setter
/** 数据源 */
- (void)setItemDataSources:(NSArray<NSString *> *)itemDataSources {
    if (itemDataSources.count == 0) {
        return;
    }
    _itemDataSources = itemDataSources;
    
    //清理数据和子控件
    [self removeCache];
    //添加indicatorView
    [self.segmentContentScrollView addSubview:self.indicatorView];
    NSInteger count = itemDataSources.count;
    //添加数据
    for (NSInteger i = 0; i < count; i++) {
        //1.标题
        NSString *title = itemDataSources[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.itemnormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.itemselectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.segmentConfig.itemfont;
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentContentScrollView addSubview:btn];
        [self.itemButtons addObject:btn];

        //2.红色角标
        UIView *redMarkV = [[UIView alloc] init];
        redMarkV.hidden = YES;
        redMarkV.tag = i;
        [self.segmentContentScrollView addSubview:redMarkV];
        [self.markViews addObject:redMarkV];
    }
    //刷新
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/** 清除数据和子控件 */
- (void)removeCache {
    //子控件从父控件上移除
    [self.segmentContentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemButtons removeAllObjects];
    [self.markViews removeAllObjects];
    self.itemButtons = nil;
}

/** 当前选中 */
- (void)setSelectIndex:(NSInteger)selectIndex {
    //过滤
    if (self.itemButtons.count == 0 || selectIndex < 0 || selectIndex > self.itemButtons.count - 1) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton *selectBtn = [self.itemButtons objectAtIndex:selectIndex];
    [self onButtonClick:selectBtn];
}

#pragma mark - 懒加载
/** 内容ScrollView */
- (UIScrollView *)segmentContentScrollView {
    if (!_segmentContentScrollView) {
        _segmentContentScrollView = [[UIScrollView alloc] init];
    }
    return _segmentContentScrollView;
}

/** 指示器 */
- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.segmentConfig.indicatorHeight;
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH, 50, indicatorH)];
        _indicatorView.backgroundColor = self.segmentConfig.indicatorColor;
    }
    return _indicatorView;
}

/** item 数组 */
- (NSMutableArray<UIButton *> *)itemButtons {
    if (!_itemButtons) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}

/** 小红点 */
- (NSMutableArray<UIView *> *)markViews {
    if (!_markViews) {
        _markViews = [NSMutableArray array];
    }
    return _markViews;
}

/** 配置信息 */
- (RevanSegmentConfig *)segmentConfig {
    if (!_segmentConfig) {
        _segmentConfig = [RevanSegmentConfig segmentDefaultConfig];
    }
    return _segmentConfig;
}

- (UIView *)segmentTopLine {
    if (!_segmentTopLine) {
        _segmentTopLine = [[UIView alloc] init];
        _segmentTopLine.backgroundColor = self.segmentConfig.segmentTopLine_color;
    }
    return _segmentTopLine;
}

- (UIView *)segmentBottomLine {
    if (!_segmentBottomLine) {
        _segmentBottomLine = [[UIView alloc] init];
        _segmentBottomLine.backgroundColor = self.segmentConfig.segmentBottomLine_color;
    }
    return _segmentBottomLine;
}

@end

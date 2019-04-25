//
//  RevanSegmentViewController.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2017/12/26.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import "RevanSegmentViewController.h"
#import "RevanSegmentedView.h"

@interface RevanSegmentViewController ()<UIScrollViewDelegate, RevanSegmentedViewDelegate> {
    NSInteger _itemSelectIndex;
}
/** 分页选项卡 */
@property (nonatomic, strong) RevanSegmentedView *segmentedView;
/** 最底层ScrollView */
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation RevanSegmentViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}


#pragma mark - public
/**
 创建上下联动的控件
 
 @param childVCs 子控制器数组
 @param items 与子控制器相对应的标题
 @param selectIndex 默认选中Item
 */
- (void)revan_segmentVCWithChilds:(NSArray <UIViewController *>*)childVCs segmentItems:(NSArray <NSString *>*)items segmentViewFrame:(CGRect)rect defaultSelectIndex:(NSInteger)selectIndex {
    self.segmentedView.frame = rect;
    _itemSelectIndex = selectIndex;
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    
    //设置标题列表
    self.segmentedView.itemDataSources = items;
    //默认选中
    self.segmentedView.selectIndex = selectIndex;
    //添加子控制器
    [self setupChildViewVC:childVCs];
    //显示当前加载的控制器
    [self showChildVCViewsAtIndex:selectIndex];
    
    //设置UIScrollView的contentSize
    self.contentScrollView.contentSize = CGSizeMake(childVCs.count * self.view.width, 0);
}

/**
 更新SegmentConfig的配置信息
 
 @param configBlock segmentConfig配置信息
 */
- (void)revan_updateWithConfig:(void(^)(RevanSegmentConfig *segmentConfig)) configBlock {
    if (configBlock) {
        [self.segmentedView updateSegmentConfig:configBlock];
    }
}

/**
 segment Tab是否显示 角标
 
 @param index tab 索引
 @param isShow 是否显示
 */
- (void)revan_segmentTabIndex:(NSInteger)index showMark:(BOOL)isShow {
    [self.segmentedView segmentTabIndex:index showMark:isShow];
}

/** 外界自动滑动 */
- (void)revan_automaticShowChildVCViewsAtIndex:(NSInteger)index {
    self.segmentedView.selectIndex = index;
    [self showChildVCViewsAtIndex:index];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setupUI];
}

/** 初始化 */
- (void)setupUI {
    //标题列表
    [self.view addSubview:self.segmentedView];
    //子控制器承载ScrollView
    [self.view addSubview:self.contentScrollView];
    NSLog(@"%zd----%@", self.view.subviews.count, self.view.subviews);
    
}

#pragma mark - 布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //标题列表
    if (self.view == self.segmentedView.superview) {
        self.contentScrollView.frame = CGRectMake(self.segmentedView.x, self.segmentedView.bottom, self.view.width, self.view.height - self.segmentedView.bottom);
        return;
    }
    //子控制器承载视图
    self.contentScrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

#pragma mark - 添加子控制器
/** 添加子控制器 */
- (void)setupChildViewVC:(NSArray <UIViewController *>*)childVCs {
    //移除子控制器
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (UIViewController *subVC in childVCs) {
        [self addChildViewController:subVC];
    }
}

/** 添加子控制器view */
- (void)showChildVCViewsAtIndex:(NSInteger)index {
    if (self.childViewControllers.count == 0 || index < 0) {
        return;
    }
    if (index > self.childViewControllers.count - 1) {
        index = 0;
    }
    
    CGFloat contentW = self.contentScrollView.width;
    CGFloat contentX = contentW * index;
    CGFloat contentY = 0;
    CGFloat contentH = self.contentScrollView.height - contentY;
    UIViewController *subVC = self.childViewControllers[index];
    subVC.view.frame = CGRectMake(contentX, contentY, contentW, contentH);
    [self.contentScrollView addSubview:subVC.view];
    
    [self.contentScrollView setContentOffset:CGPointMake(contentX, 0) animated:YES];
    if (self.segmentViewControllerBlock) {
        self.segmentViewControllerBlock(subVC, index);
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    _itemSelectIndex = selectIndex;
}


#pragma mark - UIScrollViewDelegate 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.segmentedView.selectIndex = index;
    [self showChildVCViewsAtIndex:index];
}


#pragma mark - RevanSegmentedViewDelegate
- (void)revan_segmentedView:(RevanSegmentedView *)segmentedView didSelectButton:(UIButton *)selectBtn disButton:(UIButton *)disBtn {
    [self showChildVCViewsAtIndex:selectBtn.tag];
}

#pragma mark - 懒加载
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (RevanSegmentedView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [RevanSegmentedView instanceSegment];
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}

- (UIView *)segmentBar {
    return self.segmentedView;
}
@end

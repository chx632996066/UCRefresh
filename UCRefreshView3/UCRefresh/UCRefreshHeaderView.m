//
//  UCRefreshHeaderView.m
//  UCRefresh_iOS
//
//  Created by hongxi on 16/5/20.
//  Copyright (c) 2016 hongxi. All rights reserved.
//

#import "UCRefreshHeaderView.h"
#import "UCRefreshBase.h"
#import "ProgressCircleView.h"


@interface UCRefreshHeaderView () {
    CGFloat originInsetTop;
}

@property(strong, nonatomic) UIPanGestureRecognizer *pan;

@property (strong, nonatomic) ProgressCircleView *circleView;

@end

@implementation UCRefreshHeaderView

+ (instancetype)headerWithRefreshingBlock:(UCRefreshingBlock)refreshingBlock {
    UCRefreshHeaderView *refreshHeaderView = [[UCRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -kRefreshHeaderViewHeight, kScreenWidth, 0)];
//    refreshHeaderView.clipsToBounds = YES;
    refreshHeaderView.refreshingBlock = refreshingBlock;
    return refreshHeaderView;
}

- (ProgressCircleView *)circleView {
    if (_circleView == nil){
        _circleView = [[ProgressCircleView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kRefreshHeaderViewHeight)];
        [self addSubview:_circleView];
    }
    return _circleView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.circleView.frame = CGRectMake(0,MAX(0,(self.frame.size.height-kRefreshHeaderViewHeight)/2),kScreenWidth,MIN(frame.size.height,kRefreshHeaderViewHeight));
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    // 旧的父控件移除监听
    [self removeObservers];

    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *) newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;

        // 添加监听
        [self addObservers];
    }
}

#pragma mark - KVO监听

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:@"state" options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;

    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    }

    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    else {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {

    CGFloat offsetY = MAX(0,-(self.scrollView.contentOffset.y + self.scrollView.contentInset.top));

    NSLog(@"offsetY  %f",offsetY);

    if (_isRefreshing){
        self.frame = CGRectMake(0,-kRefreshHeaderViewHeight,kScreenWidth,kRefreshHeaderViewHeight);
        self.circleView.offsetY = kRefreshHeaderViewHeight;
    }
    else{
        self.frame = CGRectMake(0,-offsetY,kScreenWidth,offsetY);
        self.circleView.offsetY = offsetY;

    }


}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {

}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    NSLog(@"scrollViewPanStateDidChange");

    if ([change[@"new"] isKindOfClass:[NSNumber class]] && [change[@"new"] intValue] == 3) {
        NSLog(@"手势结束");
        self.progress = 1.0;
        if (!self.isRefreshing && self.progress == 1.0) {
            NSLog(@"开始刷新");
            self.isRefreshing = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self shouldRefreshViewBeLocked:YES];
                             }
            ];
            [self animateWhileRefreshing];
            self.refreshingBlock();

        }
    }
}



- (void)shouldRefreshViewBeLocked:(BOOL)shouldLock {
    self.layer.cornerRadius =15;
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = shouldLock ?
            (contentInset.top + kRefreshHeaderViewHeight) : (contentInset.top - kRefreshHeaderViewHeight);
    self.scrollView.contentInset = contentInset;
}

- (void)animateWhilePulling {

}

- (void)animateWhileRefreshing {

}


- (void)endRefreshing {
    NSLog(@"END");

    [UIView animateWithDuration: 0.3
                         animations:^{
                             [self shouldRefreshViewBeLocked:NO];
                         }
                         completion:^(BOOL completed) {
                             _isRefreshing = NO;
                         }
           ];


}


@end
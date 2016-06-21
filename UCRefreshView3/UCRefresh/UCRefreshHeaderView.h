//
//  UCRefreshHeaderView.h
//  UCRefresh_iOS
//
//  Created by hongxi on 16/5/20.
//  Copyright (c) 2016 hongxi. All rights reserved.
//

#import <UIKit/UIKit.h>



/** 进入刷新状态的回调 */
typedef void (^UCRefreshingBlock)();

@interface UCRefreshHeaderView : UIView

/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

/** 正在刷新的回调 */
@property (copy, nonatomic) UCRefreshingBlock refreshingBlock;
/** 下拉进度 */
@property (nonatomic, assign) CGFloat progress;
/** 是否正在刷新 */
@property (nonatomic, assign) BOOL isRefreshing;



+ (instancetype)headerWithRefreshingBlock:(UCRefreshingBlock)refreshingBlock;

- (void)animateWhilePulling;

- (void)animateWhileRefreshing;

- (void)endRefreshing;

- (void)shouldRefreshViewBeLocked:(BOOL)shouldLock;

@end


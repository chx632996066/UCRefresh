//
// Created by hongxi on 16/5/20.
// Copyright (c) 2016 hongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCRefreshHeaderView;

@interface UIScrollView (UCRefresh)

/** 下拉刷新控件 */
@property (strong, nonatomic) UCRefreshHeaderView *ucRefreshHeader;

@end
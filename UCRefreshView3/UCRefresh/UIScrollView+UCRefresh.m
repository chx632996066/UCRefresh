//
// Created by hongxi on 16/5/20.
// Copyright (c) 2016 hongxi. All rights reserved.
//

#import "UIScrollView+UCRefresh.h"
#import "UCRefreshHeaderView.h"
#import <objc/runtime.h>

@implementation UIScrollView (UCRefresh)

#pragma mark - header
static const char UCRefreshHeaderKey = '\0';
- (void)setUcRefreshHeader:(UCRefreshHeaderView *)ucRefreshHeader {
    if(ucRefreshHeader != self.ucRefreshHeader){
        // 删除旧的，添加新的
        [self.ucRefreshHeader removeFromSuperview];
        [self addSubview:ucRefreshHeader];
        [self bringSubviewToFront:ucRefreshHeader];
        // 存储新的
        [self willChangeValueForKey:@"uc_header"]; // KVO
        objc_setAssociatedObject(self, &UCRefreshHeaderKey,
                ucRefreshHeader, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"uc_header"]; // KVO
    }
}

- (UCRefreshHeaderView *)ucRefreshHeader {
    return objc_getAssociatedObject(self, &UCRefreshHeaderKey);
}



@end

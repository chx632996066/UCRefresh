//
//  ProgressCircleView.h
//  UCRefreshView3
//
//  Created by hongxi on 16/6/6.
//  Copyright (c) 2016 hongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCircleView : UIView

@property (assign, nonatomic) CGFloat offsetY;

- (void)animateWhileRefreshing;

@end

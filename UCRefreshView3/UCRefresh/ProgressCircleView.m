//
//  ProgressCircleView.m
//  UCRefreshView3
//
//  Created by hongxi on 16/6/6.
//  Copyright (c) 2016 hongxi. All rights reserved.
//

#import "ProgressCircleView.h"
#import "UCRefreshBase.h"

@implementation ProgressCircleView{
    UIColor *_circleColor;

    CGPoint _centralPoint;  //圆心
    CGRect ellipseRect;     //椭圆Rect
    CGFloat ellipseWidth;   //椭圆的宽度
    CGFloat ellipseHeight;  //椭圆的高度
    CGFloat circleTopSpacing;

    CADisplayLink *displayLink;

    NSArray *angleArr;
    NSArray *colorArr;

    int currentCircleIndex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentMode:UIViewContentModeRedraw];
        _circleColor = [UIColor colorWithRed:47.0f/255.0f green:151.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
        circleTopSpacing = kRefreshHeaderViewHeight / 2 - kCircleRadius;


        angleArr = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:2*M_PI/3],[NSNumber numberWithFloat:2*M_PI*2/3]];
        colorArr = @[[UIColor colorWithRed:47.0f/255.0f green:151.0f/255.0f blue:252.0f/255.0f alpha:1.0f],
                [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f],
                [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        currentCircleIndex = 0;
    }
    return self;
}

/***
 * 屏幕转向改变时需要重绘
 */
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;

    if (offsetY < circleTopSpacing) {
        //下拉一下段才开始出现圆
        return;
    }

    _centralPoint = CGPointMake(self.frame.size.width / 2,MIN(kCircleRadius + circleTopSpacing * (offsetY-circleTopSpacing) / (kRefreshHeaderViewHeight - circleTopSpacing), kRefreshHeaderViewHeight / 2));

    NSLog(@"offset  %f circleY %f",offsetY, _centralPoint.y - kCircleRadius);
    //计算椭圆宽度
    //本来椭圆和圆的宽度应该是一致的, 但是这样一开始的时候就马上会有个半圆弧,比较突兀,所以一开始椭圆的宽度比圆大4,就只显示一部分圆弧,然后慢慢变回相等
    ellipseWidth = kCircleRadius * 2 + (2 - MIN(2, (offsetY - kCircleRadius) * 2 / kCircleRadius));

    //计算椭圆高度度
    ellipseHeight = MAX(-kCircleRadius * 2, 2 * kCircleRadius - (offsetY - circleTopSpacing) * 4 * kCircleRadius / (kRefreshHeaderViewHeight - circleTopSpacing));
    //计算椭圆的Rect
    ellipseRect = CGRectMake(_centralPoint.x - ellipseWidth / 2, _centralPoint.y - ellipseHeight / 2, ellipseWidth, ellipseHeight);

    [self setNeedsDisplay];

}

- (void)animateWhileRefreshing {
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCircleView)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [displayLink setFrameInterval:10];
    displayLink.paused = NO;
}

- (void)updateCircleView{


    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    //底部圆
//    CGContextSetFillColorWithColor(context,_circleColor.CGColor);
//    CGContextAddArc(context, _centralPoint.x, _centralPoint.y, kCircleRadius, 0, 2*M_PI, 1);
//    CGContextClosePath(context);
//    CGContextFillPath(context);

    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);

    //底部Circle
    CGContextSetRGBFillColor(context, 47.0f / 255.0f, 151.0f / 255.0f, 252.0f / 255.0f, 1);
    CGContextAddArc(context, _centralPoint.x, _centralPoint.y, kCircleRadius, 0, M_PI, 1);
    CGContextMoveToPoint(context, _centralPoint.x - kCircleRadius, _centralPoint.y);
    CGContextClosePath(context);
    CGContextFillPath(context);

    if (ellipseRect.size.height > 0) {
        CGContextSetRGBFillColor(context, 255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0f, 1);
    }
    else {
        CGContextSetRGBFillColor(context, 47.0f / 255.0f, 151.0f / 255.0f, 252.0f / 255.0f, 1);
    }
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextClosePath(context);
    CGContextFillPath(context);
}


@end

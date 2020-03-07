//
//  LCHeaderRefreshView.m
//  LCMoments
//
//  Created by Richard on 2020/3/2.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCHeaderRefreshView.h"

#define kHeadHeight  60

@interface  LCHeaderRefreshView ()

@property (weak, nonatomic) UIImageView* rotateImage;

@end

@implementation LCHeaderRefreshView

- (void)prepare {
    [super prepare];
    self.ignoredScrollViewContentInsetTop = - 60;
    self.mj_h = kHeadHeight;
    UIImageView* rotateImage = [[UIImageView alloc]
                                 initWithImage:[UIImage imageNamed:@"refresh"]];
    [self addSubview:rotateImage];
    self.rotateImage = rotateImage;
    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)placeSubviews {
    [super placeSubviews];
    self.rotateImage.frame = CGRectMake(30, 30, 30, 30);
}

#pragma mark 监听scrollView的contentOffset改变

- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change {
    [super scrollViewContentOffsetDidChange:change];

    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
    CGFloat pullingY = fabs(self.scrollView.mj_offsetY + 64 +
                            self.ignoredScrollViewContentInsetTop);
    if (pullingY >= kHeadHeight) {
        CGFloat marginY = -kHeadHeight - (pullingY - kHeadHeight) -
        self.ignoredScrollViewContentInsetTop;
        self.mj_y = marginY ;
    }
    [self startAnimation];
}

- (void)startAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.04;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = YES;
    [self.rotateImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

@end

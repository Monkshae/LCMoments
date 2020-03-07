//
//  LCAnimatedTransition.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCAnimatedTransition.h"

@implementation LCAnimatedTransition

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _showType = _hideType = LCTransitionTypeCoherent;
        _showDuration = _hideDuration = 0.25;
    }
    return self;
}

#pragma mark - <YBIBAnimationHandler>

- (void)lc_showTransitioningWithContainer:(UIView *)container
                                startView:(__kindof UIView *)startView
                               startImage:(UIImage *)startImage
                                 endFrame:(CGRect)endFrame
                               completion:(void (^)(void))completion {
    LCTransitionType type = self.showType;
    if (type == LCTransitionTypeCoherent) {
        if (CGRectIsEmpty(endFrame) || !startView ) {
            type = LCTransitionTypeFade;
        }
    }
    
    switch (type) {
        case LCTransitionTypeNone: {
            completion();
        }
            break;
        case LCTransitionTypeFade: {
            
            BOOL animateValid = !CGRectIsEmpty(endFrame) && startView;
            
            UIImageView *animateImageView;
            if (animateValid) {
                animateImageView = [self imageViewAssimilateToView:startView];
                animateImageView.frame = endFrame;
                animateImageView.image = startImage;
                [container addSubview:animateImageView];
            }
            
            CGFloat rawAlpha = container.alpha;
            container.alpha = 0;
            
            if (!animateValid) completion();
                
            [UIView animateWithDuration:self.showDuration animations:^{
                container.alpha = rawAlpha;
            } completion:^(BOOL finished) {
                if (animateValid) {
                    [animateImageView removeFromSuperview];
                    completion();
                }
            }];
            
        }
            break;
        case LCTransitionTypeCoherent: {
            
            UIImageView *animateImageView = [self imageViewAssimilateToView:startView];
            animateImageView.frame = [startView convertRect:startView.bounds toView:container];
            animateImageView.image = startImage;
            
            [container addSubview:animateImageView];
            
            UIColor *rawBackgroundColor = container.backgroundColor;
            container.backgroundColor = [rawBackgroundColor colorWithAlphaComponent:0];
            
            [UIView animateWithDuration:self.showDuration animations:^{
                animateImageView.frame = endFrame;
                container.backgroundColor = rawBackgroundColor;
            } completion:^(BOOL finished) {
                completion();
                // Disappear smoothly.
                [UIView animateWithDuration:0.2 animations:^{
                    animateImageView.alpha = 0;
                } completion:^(BOOL finished) {
                    [animateImageView removeFromSuperview];
                }];
            }];
            
        }
            break;
    }
}

- (void)lc_hideTransitioningWithContainer:(UIView *)container
                                startView:(__kindof UIView *)startView
                                  endView:(UIView *)endView
                               completion:(void (^)(void))completion {
    LCTransitionType type = self.hideType;
    if (type == LCTransitionTypeCoherent && (!startView || !endView)) {
        type = LCTransitionTypeFade;
    }
    
    switch (type) {
        case LCTransitionTypeNone: {
            completion();
        }
            break;
        case LCTransitionTypeFade: {
            
            CGFloat rawAlpha = container.alpha;
            
            [UIView animateWithDuration:self.hideDuration animations:^{
                container.alpha = 0;
            } completion:^(BOOL finished) {
                completion();
                container.alpha = rawAlpha;
            }];
            
        }
            break;
        case LCTransitionTypeCoherent: {
            
            CGRect startFrame = startView.frame;
            CGRect endFrame = [endView convertRect:endView.bounds toView:startView.superview];
            
            UIColor *rawBackgroundColor = container.backgroundColor;
            
            [UIView animateWithDuration:self.hideDuration animations:^{
                
                container.backgroundColor = [rawBackgroundColor colorWithAlphaComponent:0];
                
                startView.contentMode = endView.contentMode;
                
                CGAffineTransform transform = startView.transform;
                
                if ([startView isKindOfClass:UIImageView.self]) {
                    startView.frame = endFrame;
                    startView.transform = transform;
                } else {
                    CGFloat scale = MAX(endFrame.size.width / startFrame.size.width, endFrame.size.height / startFrame.size.height);
                    startView.center = CGPointMake(endFrame.size.width * startView.layer.anchorPoint.x + endFrame.origin.x, endFrame.size.height * startView.layer.anchorPoint.y + endFrame.origin.y);
                    startView.transform = CGAffineTransformScale(transform, scale, scale);
                }
                
            } completion:^(BOOL finished) {
                completion();
                container.backgroundColor = rawBackgroundColor;
            }];
            
        }
            break;
    }
}

#pragma mark - private

- (UIImageView *)imageViewAssimilateToView:(nullable __kindof UIView *)view {
    UIImageView *animateImageView = [UIImageView new];
    if ([view isKindOfClass:UIImageView.self]) {
        animateImageView.contentMode = view.contentMode;
    } else {
        animateImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    animateImageView.layer.masksToBounds = view.layer.masksToBounds;
    animateImageView.layer.cornerRadius = view.layer.cornerRadius;
    animateImageView.layer.backgroundColor = view.layer.backgroundColor;
    return animateImageView;
}

@end

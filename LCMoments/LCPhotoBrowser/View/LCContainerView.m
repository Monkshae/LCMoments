//
//  LCContainerView.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContainerView.h"

#import <objc/runtime.h>

@implementation NSObject (LCImageBrowser)

static void *LCOriginAlphaKey = &LCOriginAlphaKey;

- (void)setLc_originAlpha:(CGFloat)lc_originAlpha {
    objc_setAssociatedObject(self, LCOriginAlphaKey, @(lc_originAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lc_originAlpha {
    NSNumber *alpha = objc_getAssociatedObject(self, LCOriginAlphaKey);
    return alpha ? alpha.floatValue : 1;
}

@end

@implementation LCContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *originView = [super hitTest:point withEvent:event];
    if ([originView isKindOfClass:self.class]) {
        // Continue hit-testing if the view is kind of 'self.class'.
        return nil;
    }
    return originView;
}

@end

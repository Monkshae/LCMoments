//
//  LCTools.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCTools.h"

BOOL LCIsIphoneXSeries(void) {
    return LCStatusbarHeight() > 20;
}

CGFloat LCStatusbarHeight(void) {
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    if (height <= 0) {
        height = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    if (height <= 0) {
        height = 20;
    }
    return height;
}

CGFloat LCSafeAreaBottomHeight(void) {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return bottom;
}

UIImage *LCSnapshotView(UIView *view) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@implementation LCTools

@end

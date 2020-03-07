//
//  LCImageLayout.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCImageLayout.h"

@implementation LCImageLayout

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _zoomScaleSurplus = 1.5;
    }
    return self;
}

#pragma mark - LCImageLayout

- (CGRect)lc_imageViewFrameWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize {
    if (containerSize.width <= 0 || containerSize.height <= 0 || imageSize.width <= 0 || imageSize.height <= 0) return CGRectZero;
    
    CGFloat x = 0, y = 0, width = 0, height = 0;
    if (imageSize.width / imageSize.height >= containerSize.width / containerSize.height) {
        width = containerSize.width;
        height = containerSize.width * (imageSize.height / imageSize.width);
        x = 0;
        y = (containerSize.height - height) / 2.0;
    } else {
        height = containerSize.height;
        width = containerSize.height * (imageSize.width / imageSize.height);
        x = (containerSize.width - width) / 2.0;
        y = 0;
    }
    return CGRectMake(x, y, width, height);
}

- (CGFloat)lc_maximumZoomScaleWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize {
    if (self.maxZoomScale >= 1) return self.maxZoomScale;
    
    if (containerSize.width <= 0 || containerSize.height <= 0) return 0;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale <= 0) return 0;
    
    CGFloat maxScale = 1;
//    FillTypeCompletely
    return MAX(maxScale, 1) * self.zoomScaleSurplus;
}

@end

//
//  LCImageLayout.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCImageLayout <NSObject>
@required

- (CGRect)lc_imageViewFrameWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize;

- (CGFloat)lc_maximumZoomScaleWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize;

@end

@interface LCImageLayout : NSObject <LCImageLayout>

/// 最大缩放比例
@property (nonatomic, assign) CGFloat maxZoomScale;

/// 缩放比例 默认 1.5
@property (nonatomic, assign) CGFloat zoomScaleSurplus;

@end

NS_ASSUME_NONNULL_END

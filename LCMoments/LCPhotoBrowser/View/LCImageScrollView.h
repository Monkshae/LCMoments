//
//  LCImageScrollView.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCImageScrollView : UIScrollView

- (void)setImage:(__kindof UIImage *)image;

@property (nonatomic, strong, readonly) UIImageView *imageView;

- (void)reset;

@end

NS_ASSUME_NONNULL_END

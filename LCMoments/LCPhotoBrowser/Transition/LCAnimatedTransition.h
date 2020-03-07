//
//  LCAnimatedTransition.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCAnimatedTransition <NSObject>
@required

- (void)lc_showTransitioningWithContainer:(UIView *)container
                                startView:(nullable __kindof UIView *)startView
                               startImage:(nullable UIImage *)startImage
                                 endFrame:(CGRect)endFrame
                               completion:(void(^)(void))completion;

- (void)lc_hideTransitioningWithContainer:(UIView *)container
                                startView:(nullable __kindof UIView *)startView
                                  endView:(UIView *)endView
                               completion:(void(^)(void))completion;

@end


typedef NS_ENUM(NSInteger, LCTransitionType) {
    /// 无动效
    LCTransitionTypeNone,
    /// 渐隐
    LCTransitionTypeFade,
    /// 连贯移动
    LCTransitionTypeCoherent
};

@interface LCAnimatedTransition : NSObject <LCAnimatedTransition>

/// 入场动效类型
@property (nonatomic, assign) LCTransitionType showType;
/// 出场动效类型
@property (nonatomic, assign) LCTransitionType hideType;

/// 入场动效持续时间
@property (nonatomic, assign) NSTimeInterval showDuration;
/// 出场动效持续时间
@property (nonatomic, assign) NSTimeInterval hideDuration;

@end

NS_ASSUME_NONNULL_END

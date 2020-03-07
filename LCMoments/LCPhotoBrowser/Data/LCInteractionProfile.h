//
//  LCInteractionProfile.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCInteractionProfile : NSObject

/// 是否取消手势交互动效
@property (nonatomic, assign) BOOL disable;

/// 拖动的距离与最大高度的比例，达到这个比例就会出场
@property (nonatomic, assign) CGFloat dismissScale;

/// 拖动的速度，达到这个值就会出场
@property (nonatomic, assign) CGFloat dismissVelocityY;

/// 拖动动效复位时的时长
@property (nonatomic, assign) CGFloat restoreDuration;

/// 拖动触发手势交互动效的起始距离
@property (nonatomic, assign) CGFloat triggerDistance;

@end

NS_ASSUME_NONNULL_END

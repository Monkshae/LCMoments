//
//  LCInteractionProfile.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCInteractionProfile.h"

@implementation LCInteractionProfile


- (instancetype)init {
    self = [super init];
    if (self) {
        _disable = NO;
        _dismissScale = 0.22;
        _dismissVelocityY = 800;
        _restoreDuration = 0.15;
        _triggerDistance = 3;
    }
    return self;
}

@end

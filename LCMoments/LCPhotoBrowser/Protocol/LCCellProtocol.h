//
//  LCCellProtocol.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCGetBaseInfoProtocol.h"

@protocol LCDataProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol LCCellProtocol <LCGetBaseInfoProtocol>

@required

/// Cell 对应的 Data
@property (nonatomic, strong) id<LCDataProtocol> lc_cellData;

@optional

/**
 获取前景视图，出入场时需要用这个返回值做动效

 @return 前景视图
 */
- (__kindof UIView *)lc_foregroundView;

@end

NS_ASSUME_NONNULL_END

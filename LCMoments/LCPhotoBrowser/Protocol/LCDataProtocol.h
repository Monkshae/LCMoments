//
//  LCDataProtocol.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCGetBaseInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LCDataProtocol <LCGetBaseInfoProtocol>

@required

/// 当前 Data 对应 Cell 的类类型

- (Class)lc_classOfCell;

@optional

 /// 获取投影视图
- (__kindof UIView *)lc_projectiveView;

/// 计算并返回图片视图在容器中的 frame
- (CGRect)lc_imageViewFrameWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END

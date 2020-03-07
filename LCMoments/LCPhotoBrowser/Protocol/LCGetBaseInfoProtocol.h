//
//  LCGetBaseInfoProtocol.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCDefaultWebImageMediator.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LCGetBaseInfoProtocol <NSObject>

@optional

/// 容器大小
@property (nonatomic, copy) CGSize(^lc_containerSize)(void);

/// 图片下载缓存相关中介者
@property (nonatomic, copy) id<LCWebImageMediator>(^lc_webImageMediator)(void);

/// 判断当前展示的 cell 是否恰好在屏幕中间
@property (nonatomic, copy) BOOL(^lc_cellIsInCenter)(void);

/// 是否正在隐藏过程转场
@property (nonatomic, copy) BOOL(^lc_isHideTransitioning)(void);

/// 背景视图
@property (nonatomic, weak) __kindof UIView *lc_backView;

/// 集合视图
@property (nonatomic, copy) __kindof UICollectionView *(^lc_collectionView)(void);

/// 隐藏图片浏览器
@property (nonatomic, copy) void(^lc_hideBrowser)(void);

/// 是否隐藏状态栏
@property (nonatomic, copy) void(^lc_hideStatusBar)(BOOL);

@end

NS_ASSUME_NONNULL_END

//
//  LCImageBrowser.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCollectionView.h"
#import "LCImageBrowserDelegate.h"
#import "LCDataProtocol.h"
#import "LCCellProtocol.h"
#import "LCAnimatedTransition.h"
#import "LCDefaultWebImageMediator.h"
#import "LCImageData.h"
#import "LCContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCImageBrowser : UIView

@property (nonatomic, strong) LCContainerView *containerView;

@property (nonatomic, weak, nullable) NSObject *hiddenProjectiveView;

- (void)implementGetBaseInfoProtocol:(id<LCGetBaseInfoProtocol>)obj;

/// 数据源数组
@property (nonatomic, copy) NSArray<id<LCDataProtocol>> *dataSourceArray;

/// 数据源代理
@property (nonatomic, weak) id<LCImageBrowserDataSource> dataSource;

/// 状态回调代理
@property (nonatomic, weak) id<LCImageBrowserDelegate> delegate;

/**
 展示图片浏览器

 @param view 指定父视图（view 的大小不能为 CGSizeZero，但允许变化）
 @param containerSize 容器大小（当 view 的大小允许变化时，必须指定确切的 containerSize）
 */
- (void)showToView:(UIView *)view containerSize:(CGSize)containerSize;
- (void)showToView:(UIView *)view;
- (void)show;

/**
 隐藏图片浏览器（不建议外部持有图片浏览器重复使用）
 */
- (void)hide;

/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

/// 分页间距
@property (nonatomic, assign) CGFloat distanceBetweenPages;

/// 是否自动隐藏 id<YBIBImageData> 设置的映射视图，默认为 YES
@property (nonatomic, assign) BOOL autoHideProjectiveView;

/// 是否正在进行隐藏过程转场
@property (nonatomic, assign, readonly, getter=isHideTransitioning) BOOL hideTransitioning;

/**
 重载数据，请保证数据源被正确修改
 */
- (void)reloadData;

/**
 获取当前展示的数据对象

 @return 数据对象
 */
- (id<LCDataProtocol>)currentData;

/// 是否隐藏状态栏，默认为 YES（该值为 YES 时需要在 info.plist 中添加 View controller-based status bar appearance : NO 才能生效）
@property (nonatomic, assign) BOOL shouldHideStatusBar;

/// 转场实现类 (赋值可自定义)
@property (nonatomic, strong) id<LCAnimatedTransition> animatedTransition;
/// 默认转场实现类 (可配置其属性)
@property (nonatomic, weak, readonly) LCAnimatedTransition *defaultAnimatedTransition;

/// 图片下载缓存相关的中介者（赋值可自定义）
@property (nonatomic, strong) id<LCWebImageMediator> webImageMediator;

/// 核心集合视图
@property (nonatomic, strong, readonly) LCCollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END

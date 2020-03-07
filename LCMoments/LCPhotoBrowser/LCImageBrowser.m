//
//  LCImageBrowser.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCImageBrowser.h"
#import "LCTools.h"
#import "LCCellProtocol.h"
#import "LCDataMediator.h"
#import "LCDefaultWebImageMediator.h"

@interface LCImageBrowser () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) LCCollectionView *collectionView;
@property (nonatomic, strong) LCDataMediator *dataMediator;
@property (nonatomic, assign) CGSize containerSize;

@end

@implementation LCImageBrowser {
    BOOL _originStatusBarHidden;
}

#pragma mark - life cycle

- (void)dealloc {
    self.hiddenProjectiveView = nil;
    [self showStatusBar];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
        [self addGestureRecognizer:longPress];
        [self initValue];
    }
    return self;
}

- (void)initValue {
    _defaultAnimatedTransition = _animatedTransition = [LCAnimatedTransition new];
    _shouldHideStatusBar = YES;
    _autoHideProjectiveView = YES;
    _webImageMediator = [LCDefaultWebImageMediator new];
}

#pragma mark - private

- (void)build {
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.containerView];
    self.containerView.frame = self.bounds;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    [self layoutIfNeeded];
    [self collectionViewScrollToPage:self.currentPage];
}

- (void)rebuild {
    self.hiddenProjectiveView = nil;
    [self showStatusBar];
    [self.containerView removeFromSuperview];
    _containerView = nil;
    [self.collectionView removeFromSuperview];
    _collectionView = nil;
    [self.dataMediator clear];
}

- (void)collectionViewScrollToPage:(NSInteger)page {
    [self.collectionView scrollToPage:page];
    [self pageNumberChanged];
}

- (void)pageNumberChanged {
    id<LCDataProtocol> data = self.currentData;
    UIView *projectiveView = nil;
    if ([data respondsToSelector:@selector(lc_projectiveView)]) {
        projectiveView = [data lc_projectiveView];
    }
    self.hiddenProjectiveView = projectiveView;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lc_imageBrowser:pageChanged:data:)]) {
        [self.delegate lc_imageBrowser:self pageChanged:self.currentPage data:data];
    }
}

- (void)showStatusBar {
    if (self.shouldHideStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = _originStatusBarHidden;
    }
}

- (void)hideStatusBar {
    if (self.shouldHideStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}

#pragma mark - public

- (void)show {
    [self showToView:[UIApplication sharedApplication].keyWindow];
}

- (void)showToView:(UIView *)view {
    [self showToView:view containerSize:view.bounds.size];
}

- (void)showToView:(UIView *)view containerSize:(CGSize)containerSize {
    
    [view addSubview:self];
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _originStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    
    _containerSize = containerSize;
    
    __kindof UIView *startView;
    UIImage *startImage;
    CGRect endFrame = CGRectZero;
    id<LCDataProtocol> data = [self.dataMediator dataForCellAtIndex:self.currentPage];
    if ([data respondsToSelector:@selector(lc_projectiveView)]) {
        startView = data.lc_projectiveView;
        self.hiddenProjectiveView = startView;
        if ([startView isKindOfClass:UIImageView.class]) {
            startImage = ((UIImageView *)startView).image;
        } else {
            startImage = LCSnapshotView(startView);
        }
    }
    if ([data respondsToSelector:@selector(lc_imageViewFrameWithContainerSize:imageSize:)]) {
        endFrame = [data lc_imageViewFrameWithContainerSize:self.bounds.size imageSize:startImage.size];
    }
    
    [self setTransitioning:YES isShow:YES];
    [self.animatedTransition lc_showTransitioningWithContainer:self startView:startView startImage:startImage endFrame:endFrame completion:^{
        [self hideStatusBar];
        [self build];
        [self setTransitioning:NO isShow:YES];
    }];
}

- (void)hide {
    __kindof UIView *startView;
    __kindof UIView *endView;
    UICollectionViewCell<LCCellProtocol> *cell = (UICollectionViewCell<LCCellProtocol> *)self.collectionView.centerCell;
    if ([cell respondsToSelector:@selector(lc_foregroundView)]) {
        startView = cell.lc_foregroundView;
    }
    if ([cell.lc_cellData respondsToSelector:@selector(lc_projectiveView)]) {
        endView = cell.lc_cellData.lc_projectiveView;
    }
    
    [self showStatusBar];
    
    [self setTransitioning:YES isShow:NO];
    [self.animatedTransition lc_hideTransitioningWithContainer:self startView:startView endView:endView completion:^{
        [self rebuild];
        [self removeFromSuperview];
        [self setTransitioning:NO isShow:NO];
    }];
}

- (void)reloadData {
    [self.dataMediator clear];
    NSInteger page = self.currentPage;
    [self.collectionView reloadData];
    self.currentPage = page;
}

- (id<LCDataProtocol>)currentData {
    return [self.dataMediator dataForCellAtIndex:self.currentPage];
}

#pragma mark - internal

- (void)setHiddenProjectiveView:(NSObject *)hiddenProjectiveView {
    if (_hiddenProjectiveView && [_hiddenProjectiveView respondsToSelector:@selector(setAlpha:)]) {
        CGFloat originAlpha = _hiddenProjectiveView.lc_originAlpha;
        if (originAlpha != 1) {
            [_hiddenProjectiveView setValue:@(1) forKey:@"alpha"];
            [UIView animateWithDuration:0.2 animations:^{
                [self->_hiddenProjectiveView setValue:@(originAlpha) forKey:@"alpha"];
            }];
        } else {
            [_hiddenProjectiveView setValue:@(originAlpha) forKey:@"alpha"];
        }
    }
    _hiddenProjectiveView = hiddenProjectiveView;
    
    if (!self.autoHideProjectiveView) return;
    
    if (hiddenProjectiveView && [hiddenProjectiveView respondsToSelector:@selector(setAlpha:)]) {
        hiddenProjectiveView.lc_originAlpha = ((NSNumber *)[hiddenProjectiveView valueForKey:@"alpha"]).floatValue;
        [hiddenProjectiveView setValue:@(0) forKey:@"alpha"];
    }
}

- (void)implementGetBaseInfoProtocol:(id<LCGetBaseInfoProtocol>)obj {
    __weak typeof(self) wSelf = self;
    if ([obj respondsToSelector:@selector(setLc_containerSize:)]) {
        [obj setLc_containerSize:^CGSize {
            __strong typeof(wSelf) self = wSelf;
            if (!self) return CGSizeZero;
            return self.containerSize;
        }];
    }

    if ([obj respondsToSelector:@selector(setLc_webImageMediator:)]) {
        [obj setLc_webImageMediator:^id<LCWebImageMediator> {
            __strong typeof(wSelf) self = wSelf;
            if (!self) return nil;
            NSAssert(self.webImageMediator, @"'webImageMediator' should not be nil.");
            return self.webImageMediator;
        }];
    }

    if ([obj respondsToSelector:@selector(setLc_backView:)]) {
        obj.lc_backView = self;
    }

    if ([obj respondsToSelector:@selector(setLc_collectionView:)]) {
        [obj setLc_collectionView:^__kindof UICollectionView *{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return nil;
            return self.collectionView;
        }];
    }
    if ([obj respondsToSelector:@selector(setLc_cellIsInCenter:)]) {
        [obj setLc_cellIsInCenter:^BOOL{
            __strong typeof(wSelf) self = wSelf;
            CGFloat pageF = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
            // '0.001' is admissible error.
            return ABS(pageF - (NSInteger)pageF) <= 0.001;
        }];
    }

    if ([obj respondsToSelector:@selector(setLc_isHideTransitioning:)]) {
        [obj setLc_isHideTransitioning:^BOOL{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return NO;
            return self.isHideTransitioning;
        }];
    }
    
    if ([obj respondsToSelector:@selector(setLc_hideBrowser:)]) {
        [obj setLc_hideBrowser:^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            [self hide];
        }];
    }
    if ([obj respondsToSelector:@selector(setLc_hideStatusBar:)]) {
        [obj setLc_hideStatusBar:^(BOOL hide) {
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            hide ? [self hideStatusBar] : [self showStatusBar];
        }];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataMediator numberOfCells];
}

- (UICollectionViewCell *)collectionView:(LCCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<LCDataProtocol> data = [self.dataMediator dataForCellAtIndex:indexPath.row];
    
    UICollectionViewCell<LCCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[collectionView reuseIdentifierForCellClass:data.lc_classOfCell] forIndexPath:indexPath];
    
    [self implementGetBaseInfoProtocol:cell];
    cell.lc_cellData = data;
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageF = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger page = (NSInteger)(pageF + 0.5);
    
    if (!scrollView.isDecelerating && !scrollView.isDragging) {
        // Return if not scrolled by finger.
        return;
    }
    if (page < 0 || page > [self.dataMediator numberOfCells] - 1) return;
    
    if (page != _currentPage) {
        _currentPage = page;
        [self pageNumberChanged];
    }
}

#pragma mark - event

- (void)respondsToLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(lc_imageBrowser:respondsToLongPressWithData:)]) {
            [self.delegate lc_imageBrowser:self respondsToLongPressWithData:[self currentData]];
        }
    }
}

#pragma mark - getters & setters

- (LCContainerView *)containerView {
    if (!_containerView) {
        _containerView = [LCContainerView new];
        _containerView.backgroundColor = UIColor.clearColor;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (LCCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [LCCollectionView new];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    NSInteger maxPage = self.dataMediator.numberOfCells - 1;
    if (currentPage > maxPage) {
        currentPage = maxPage;
    }
    _currentPage = currentPage;
    if (self.collectionView.superview) {
        [self collectionViewScrollToPage:currentPage];
    }
}
- (void)setDistanceBetweenPages:(CGFloat)distanceBetweenPages {
    self.collectionView.layout.distanceBetweenPages = distanceBetweenPages;
}
- (CGFloat)distanceBetweenPages {
    return self.collectionView.layout.distanceBetweenPages;
}

- (void)setTransitioning:(BOOL)transitioning isShow:(BOOL)isShow {
    _hideTransitioning = transitioning && !isShow;
    
    self.containerView.userInteractionEnabled = !transitioning;
    self.collectionView.userInteractionEnabled = !transitioning;
    
    if (transitioning) {
        if ([self.delegate respondsToSelector:@selector(lc_imageBrowser:beginTransitioningWithIsShow:)]) {
            [self.delegate lc_imageBrowser:self beginTransitioningWithIsShow:isShow];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(lc_imageBrowser:endTransitioningWithIsShow:)]) {
            [self.delegate lc_imageBrowser:self endTransitioningWithIsShow:isShow];
        }
    }
}

- (LCDataMediator *)dataMediator {
    if (!_dataMediator) {
        _dataMediator = [[LCDataMediator alloc] initWithBrowser:self];
    }
    return _dataMediator;
}


@end


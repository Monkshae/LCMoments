//
//  LCImageCell.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCImageCell.h"
#import "LCImageData.h"

@interface LCImageCell () <LCImageDataDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation LCImageCell {
    CGPoint _interactStartPoint;
    BOOL _interacting;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
        [self.contentView addSubview:self.imageScrollView];
        [self addGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageScrollView.frame = self.bounds;
}

- (void)initValue {
    _interactStartPoint = CGPointZero;
    _interacting = NO;
}

- (void)prepareForReuse {
    ((LCImageData *)self.lc_cellData).delegate = nil;
    [self.imageScrollView reset];
    [super prepareForReuse];
}

#pragma mark - <YBIBCellProtocol>

@synthesize lc_containerSize = _lc_containerSize;
@synthesize lc_backView = _lc_backView;
@synthesize lc_collectionView = _lc_collectionView;
@synthesize lc_hideStatusBar = _lc_hideStatusBar;
@synthesize lc_hideBrowser = _lc_hideBrowser;
@synthesize lc_cellData = _lc_cellData;
@synthesize lc_cellIsInCenter = _lc_cellIsInCenter;

- (void)setLc_cellData:(id<LCDataProtocol>)lc_cellData {
    _lc_cellData = lc_cellData;
    ((LCImageData *)lc_cellData).delegate = self;
}

- (UIView *)lc_foregroundView {
    return self.imageScrollView.imageView;
}

#pragma mark - private

- (CGSize)contentSizeWithContainerSize:(CGSize)containerSize imageViewFrame:(CGRect)imageViewFrame {
    return CGSizeMake(MAX(containerSize.width, imageViewFrame.size.width), MAX(containerSize.height, imageViewFrame.size.height));
}

- (void)updateImageLayoutWithPreviousImageSize:(CGSize)previousImageSize {
    if (_interacting) [self restoreInteractionWithDuration:0];
    
    LCImageData *data = self.lc_cellData;
    
    CGSize imageSize;
    
    UIImage *image = self.imageScrollView.imageView.image;
    imageSize = image.size;
    
    CGSize containerSize = self.lc_containerSize();
    CGRect imageViewFrame = [data.layout lc_imageViewFrameWithContainerSize:containerSize imageSize:imageSize];
    CGSize contentSize = [self contentSizeWithContainerSize:containerSize imageViewFrame:imageViewFrame];
    CGFloat maxZoomScale = [data.layout lc_maximumZoomScaleWithContainerSize:containerSize imageSize:imageSize];
    
    self.imageScrollView.zoomScale = 1;
    self.imageScrollView.contentSize = contentSize;
    self.imageScrollView.minimumZoomScale = 1;
    self.imageScrollView.maximumZoomScale = maxZoomScale;
    
    CGFloat scale;
    if (previousImageSize.width > 0 && previousImageSize.height > 0) {
        scale = imageSize.width / imageSize.height - previousImageSize.width / previousImageSize.height;
    } else {
        scale = 0;
    }
    // '0.001' is admissible error.
    if (ABS(scale) <= 0.001) {
        self.imageScrollView.imageView.frame = imageViewFrame;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageScrollView.imageView.frame = imageViewFrame;
        }];
    }
}

- (void)hideBrowser {
    ((LCImageData *)self.lc_cellData).delegate = nil;
    self.lc_hideBrowser();
    _interacting = NO;
}

#pragma mark - <YBIBImageDataDelegate>

- (void)lc_imageData:(LCImageData *)data readyForImage:(__kindof UIImage *)image {
    if (self.imageScrollView.imageView.image == image) return;
    
    CGSize size = self.imageScrollView.imageView.image.size;
    [self.imageScrollView setImage:image];
    [self updateImageLayoutWithPreviousImageSize:size];
}

- (void)lc_imageIsInvalidForData:(LCImageData *)data {

}

- (void)lc_imageData:(LCImageData *)data downloadProgress:(CGFloat)progress {

}

- (void)lc_imageDownloadFailedForData:(LCImageData *)data {

}

#pragma mark - gesture

- (void)addGesture {
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapSingle:)];
    tapSingle.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapDouble:)];
    tapDouble.numberOfTapsRequired = 2;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    
    [tapSingle requireGestureRecognizerToFail:tapDouble];
    [tapSingle requireGestureRecognizerToFail:pan];
    [tapDouble requireGestureRecognizerToFail:pan];
    
    [self addGestureRecognizer:tapSingle];
    [self addGestureRecognizer:tapDouble];
    [self addGestureRecognizer:pan];
}

- (void)respondsToTapSingle:(UITapGestureRecognizer *)tap {
    LCImageData *data = self.lc_cellData;
    if (data.singleTouchBlock) {
        data.singleTouchBlock(data);
    } else {
        self.lc_hideBrowser();
    }
}

- (void)respondsToTapDouble:(UITapGestureRecognizer *)tap {
    
    UIScrollView *scrollView = self.imageScrollView;
    UIView *zoomView = [self viewForZoomingInScrollView:scrollView];
    CGPoint point = [tap locationInView:zoomView];
    if (!CGRectContainsPoint(zoomView.bounds, point)) return;
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        [scrollView setZoomScale:1 animated:YES];
    } else {
        [scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)respondsToPan:(UIPanGestureRecognizer *)pan {
    
    LCInteractionProfile *profile = ((LCImageData *)self.lc_cellData).interactionProfile;
    if (profile.disable) return;
    if ((CGRectIsEmpty(self.imageScrollView.imageView.frame) || !self.imageScrollView.imageView.image)) return;
    
    CGPoint point = [pan locationInView:self];
    CGSize containerSize = self.lc_containerSize();
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _interactStartPoint = point;
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateRecognized || pan.state == UIGestureRecognizerStateFailed) {
        
        // End.
        if (_interacting) {
            CGPoint velocity = [pan velocityInView:self.imageScrollView];
            
            BOOL velocityArrive = ABS(velocity.y) > profile.dismissVelocityY;
            BOOL distanceArrive = ABS(point.y - _interactStartPoint.y) > containerSize.height * profile.dismissScale;
            
            BOOL shouldDismiss = distanceArrive || velocityArrive;
            if (shouldDismiss) {
                [self hideBrowser];
            } else {
                [self restoreInteractionWithDuration:profile.restoreDuration];
            }
        }
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        if (_interacting) {

            // Change.
            self.imageScrollView.center = point;
            CGFloat scale = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 1.2);
            if (scale > 1) scale = 1;
            if (scale < 0.35) scale = 0.35;
            self.imageScrollView.transform = CGAffineTransformMakeScale(scale, scale);

            CGFloat alpha = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 0.7);
            if (alpha > 1) alpha = 1;
            if (alpha < 0) alpha = 0;
            self.lc_backView.backgroundColor = [self.lc_backView.backgroundColor colorWithAlphaComponent:alpha];

        } else {

            // Start.
            if (CGPointEqualToPoint(_interactStartPoint, CGPointZero) || !self.lc_cellIsInCenter() || self.imageScrollView.isZooming) return;

            CGPoint velocity = [pan velocityInView:self.imageScrollView];
            CGFloat triggerDistance = profile.triggerDistance;
            CGFloat offsetY = self.imageScrollView.contentOffset.y, height = self.imageScrollView.bounds.size.height;

            BOOL distanceArrive = ABS(point.x - _interactStartPoint.x) < triggerDistance && ABS(velocity.x) < 500;
            BOOL upArrive = point.y - _interactStartPoint.y > triggerDistance && offsetY <= 1;
            BOOL downArrive = point.y - _interactStartPoint.y < -triggerDistance && offsetY + height >= MAX(self.imageScrollView.contentSize.height, height) - 1;

            BOOL shouldStart = (upArrive || downArrive) && distanceArrive;
            if (!shouldStart) return;

            _interactStartPoint = point;

            CGRect startFrame = self.imageScrollView.frame;
            CGFloat anchorX = point.x / startFrame.size.width, anchorY = point.y / startFrame.size.height;
            self.imageScrollView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
            self.imageScrollView.userInteractionEnabled = NO;
            self.imageScrollView.scrollEnabled = NO;
            self.imageScrollView.center = point;
            
            self.lc_hideStatusBar(NO);
            self.lc_collectionView().scrollEnabled = NO;

            _interacting = YES;
        }
    }
}

- (void)restoreInteractionWithDuration:(NSTimeInterval)duration {
    CGSize containerSize = self.lc_containerSize();
    
    void (^animations)(void) = ^{
        self.lc_backView.backgroundColor = [self.lc_backView.backgroundColor colorWithAlphaComponent:1];
        
        CGPoint anchorPoint = self.imageScrollView.layer.anchorPoint;
        self.imageScrollView.center = CGPointMake(containerSize.width * anchorPoint.x, containerSize.height * anchorPoint.y);
        self.imageScrollView.transform = CGAffineTransformIdentity;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished){
        self.imageScrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.imageScrollView.center = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
        self.imageScrollView.userInteractionEnabled = YES;
        self.imageScrollView.scrollEnabled = YES;
        
        self.lc_hideStatusBar(YES);
        self.lc_collectionView().scrollEnabled = YES;
        
        self->_interactStartPoint = CGPointZero;
        self->_interacting = NO;
    };
    
    if (duration <= 0) {
        animations();
        completion(NO);
    } else {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    LCImageData *data = self.lc_cellData;
    if (data.imageDidZoomBlock) {
        data.imageDidZoomBlock(data, scrollView);
    }
    
    CGRect imageViewFrame = self.imageScrollView.imageView.frame;
    CGFloat width = imageViewFrame.size.width,
    height = imageViewFrame.size.height,
    sHeight = scrollView.bounds.size.height,
    sWidth = scrollView.bounds.size.width;
    if (height > sHeight) {
        imageViewFrame.origin.y = 0;
    } else {
        imageViewFrame.origin.y = (sHeight - height) / 2.0;
    }
    if (width > sWidth) {
        imageViewFrame.origin.x = 0;
    } else {
        imageViewFrame.origin.x = (sWidth - width) / 2.0;
    }
    self.imageScrollView.imageView.frame = imageViewFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageScrollView.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    LCImageData *data = self.lc_cellData;
    if (data.imageDidScrollBlock) {
        data.imageDidScrollBlock(data, scrollView);
    }
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - getters

- (LCImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [LCImageScrollView new];
        _imageScrollView.delegate = self;
    }
    return _imageScrollView;
}

@end

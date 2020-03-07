//
//  LCImageData.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCImageData.h"
#import "LCImageCell.h"
#import "LCDefine.h"
#import <AssetsLibrary/AssetsLibrary.h>

extern CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay);

static dispatch_queue_t LCImageProcessingQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.yangbo.imagebrowser.imageprocessing", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@implementation LCImageData {
    __weak id _downloadToken;
    BOOL _freezing;
}

#pragma mark - life cycle

- (void)dealloc {
    if (_downloadToken && [self.lc_webImageMediator() respondsToSelector:@selector(cancelTaskWithDownloadToken:)]) {
        [self.lc_webImageMediator() cancelTaskWithDownloadToken:_downloadToken];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue {
    _defaultLayout = _layout = [LCImageLayout new];
    _loadingStatus = LCImageLoadingStatusNone;
    _freezing = NO;
    _interactionProfile = [LCInteractionProfile new];
}

#pragma mark - load data

- (void)loadData {
    _freezing = NO;
    
    if (self.originImage) {
        [self loadOriginImage];
    } else if (self.imageName || self.imagePath) {
        [self loadLocalImage];
    } else if (self.image) {
        [self loadImageBlock];
    } else if (self.imageURL) {
        [self loadURL];
    }else {
        [self.delegate lc_imageIsInvalidForData:self];
    }
}

- (void)loadOriginImage {
    if (_freezing) return;
    if (!self.originImage) return;
    
    [self.delegate lc_imageData:self readyForImage:self.originImage];
}


- (void)loadLocalImage {
    if (_freezing) return;
    NSString *name = self.imageName.copy;
    NSString *path = self.imagePath.copy;
    if (name.length == 0 && path.length == 0) return;
        
    __block UIImage *image;
    __weak typeof(self) wSelf = self;
    void(^dealBlock)(void) = ^{
        if (name.length > 0) {
            image = [UIImage imageNamed:name];
        } else if (path.length > 0) {
            image = [UIImage imageWithContentsOfFile:path];
        }
        LC_DISPATCH_ASYNC_MAIN(^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            self.loadingStatus = LCImageLoadingStatusNone;
            if (image) {
                [self setOriginImageAndLoadWithImage:image];
            } else {
                [self.delegate lc_imageIsInvalidForData:self];
            }
        })
    };
    dealBlock();
}

- (void)loadImageBlock {
    if (_freezing) return;
    __block UIImage *image = self.image ? self.image() : nil;
    if (!image) return;
        
    __weak typeof(self) wSelf = self;
    void(^dealBlock)(void) = ^{
        LC_DISPATCH_ASYNC_MAIN(^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            self.loadingStatus = LCImageLoadingStatusNone;
            [self setOriginImageAndLoadWithImage:image];
        })
    };
    dealBlock();
}

- (void)loadURL {
    if (!self.imageURL || self.imageURL.absoluteString.length == 0) return;
    [self loadURL_queryCache];
}
- (void)loadURL_queryCache {
    if (_freezing) return;
    if (!self.imageURL || self.imageURL.absoluteString.length == 0) return;
        
    [self.lc_webImageMediator() queryCacheOperationForKey:self.imageURL completed:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        if (!imageData || imageData.length == 0) {
            LC_DISPATCH_ASYNC_MAIN(^{
                self.loadingStatus = LCImageLoadingStatusNone;
                [self loadURL_download];
            })
            return;
        }
        
        LC_DISPATCH_ASYNC(LCImageProcessingQueue(), ^{
            if (self->_freezing) {
                self.loadingStatus = LCImageLoadingStatusNone;
                return;
            }
            UIImage *image = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
            __weak typeof(self) wSelf = self;
            LC_DISPATCH_ASYNC_MAIN(^{
                __strong typeof(wSelf) self = wSelf;
                if (!self) return;
                self.loadingStatus = LCImageLoadingStatusNone;
                if (image) {    // Maybe the image data is invalid.
                    [self setOriginImageAndLoadWithImage:image];
                } else {
                    [self loadURL_download];
                }
            })
        })
    }];
}
- (void)loadURL_download {
    if (_freezing) return;
    if (!self.imageURL || self.imageURL.absoluteString.length == 0) return;
        
    self.loadingStatus = LCImageLoadingStatusDownloading;
    __weak typeof(self) wSelf = self;
    _downloadToken = [self.lc_webImageMediator() downloadImageWithURL:self.imageURL requestModifier:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        return request;
    } progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = receivedSize * 1.0 / expectedSize ?: 0;
        LC_DISPATCH_ASYNC_MAIN(^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            [self.delegate lc_imageData:self downloadProgress:progress];
        })
    } success:^(NSData * _Nullable imageData, BOOL finished) {
        if (!finished) return;
        
        LC_DISPATCH_ASYNC(LCImageProcessingQueue(), ^{
            if (self->_freezing) {
                self.loadingStatus = LCImageLoadingStatusNone;
                return;
            }
            UIImage *image = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
            LC_DISPATCH_ASYNC_MAIN(^{
                __strong typeof(wSelf) self = wSelf;
                if (!self) return;
                [self.lc_webImageMediator() storeToDiskWithImageData:imageData forKey:self.imageURL];
                self.loadingStatus = LCImageLoadingStatusNone;
                if (image) {
                    [self setOriginImageAndLoadWithImage:image];
                } else {
                    [self.delegate lc_imageIsInvalidForData:self];
                }
            })
        })
    } failed:^(NSError * _Nullable error, BOOL finished) {
        if (!finished) return;
        __strong typeof(wSelf) self = wSelf;
        if (!self) return;
        self.loadingStatus = LCImageLoadingStatusNone;
        [self.delegate lc_imageDownloadFailedForData:self];
    }];
}

#pragma mark - private

- (void)setOriginImageAndLoadWithImage:(UIImage *)image {
    self.originImage = image;
    [self loadOriginImage];
}

#pragma mark - <YBIBDataProtocol>

@synthesize lc_isHideTransitioning = _lc_isHideTransitioning;
@synthesize lc_containerSize = _lc_containerSize;
@synthesize lc_webImageMediator = _lc_webImageMediator;
@synthesize lc_backView = _lc_backView;

- (nonnull Class)lc_classOfCell {
    return LCImageCell.self;
}

- (UIView *)lc_projectiveView {
    return self.projectiveView;
}

- (CGRect)lc_imageViewFrameWithContainerSize:(CGSize)containerSize imageSize:(CGSize)imageSize{
    return [self.layout lc_imageViewFrameWithContainerSize:containerSize imageSize:imageSize];
}

#pragma mark - getters & setters

@synthesize delegate = _delegate;
- (void)setDelegate:(id<LCImageDataDelegate>)delegate {
    _delegate = delegate;
    if (delegate) {
        [self loadData];
    } else {
        _freezing = YES;
    }
}

- (id<LCImageDataDelegate>)delegate {
    return self.lc_isHideTransitioning() ? nil : _delegate;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = [imageURL isKindOfClass:NSString.class] ? [NSURL URLWithString:(NSString *)imageURL] : imageURL;
}


@end

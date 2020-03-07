//
//  LCImageData.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Photos/Photos.h>
#import "LCDataProtocol.h"
#import "LCImageLayout.h"
#import "LCInteractionProfile.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LCImageLoadingStatus) {
    LCImageLoadingStatusNone,
    LCImageLoadingStatusProcessing,
    LCImageLoadingStatusDownloading,
};

@class LCImageData;

typedef NSData * _Nullable (^YBIBImageDataBlock)(void);

typedef UIImage * _Nullable (^LCImageBlock)(void);

typedef void (^LCImageSingleTouchBlock)(LCImageData *imageData);

typedef void (^LCImageScrollViewStatusBlock)(LCImageData *imageData, UIScrollView *scrollView);

@protocol LCImageDataDelegate <NSObject>
@required

- (void)lc_imageIsInvalidForData:(LCImageData *)data;

- (void)lc_imageData:(LCImageData *)data readyForImage:(__kindof UIImage *)image;

- (void)lc_imageData:(LCImageData *)data downloadProgress:(CGFloat)progress;

- (void)lc_imageDownloadFailedForData:(LCImageData *)data;

@end

@interface LCImageData : NSObject <LCDataProtocol>

@property (nonatomic, copy, nullable) NSString *imageName;

@property (nonatomic, copy, nullable) NSString *imagePath;

@property (nonatomic, copy, nullable) LCImageBlock image;

@property (nonatomic, copy, nullable) NSURL *imageURL;

@property (nonatomic, weak, nullable) __kindof UIView *projectiveView;

@property (nonatomic, strong) LCInteractionProfile *interactionProfile;

@property (nonatomic, copy, nullable) LCImageSingleTouchBlock singleTouchBlock;

@property (nonatomic, copy, nullable) LCImageScrollViewStatusBlock imageDidScrollBlock;

@property (nonatomic, copy, nullable) LCImageScrollViewStatusBlock imageDidZoomBlock;

@property (nonatomic, strong) id<LCImageLayout> layout;

@property (nonatomic, weak, readonly) LCImageLayout *defaultLayout;

@property (nonatomic, weak) id<LCImageDataDelegate> delegate;

@property (nonatomic, assign) LCImageLoadingStatus loadingStatus;

@property (nonatomic, strong) UIImage *originImage;

@end

NS_ASSUME_NONNULL_END

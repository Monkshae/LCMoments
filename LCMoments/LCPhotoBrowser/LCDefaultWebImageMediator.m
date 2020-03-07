//
//  LCDefaultWebImageMediator.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCDefaultWebImageMediator.h"
#import "LCDefine.h"

@implementation LCDefaultWebImageMediator

#pragma mark - <YBIBWebImageMediator>

- (id)downloadImageWithURL:(NSURL *)URL requestModifier:(nullable LCWebImageRequestModifierBlock)requestModifier progress:(nonnull LCWebImageProgressBlock)progress success:(nonnull LCWebImageSuccessBlock)success failed:(nonnull LCWebImageFailedBlock)failed {
    if (!URL) return nil;
    
    SDWebImageContext *context = nil;
    if (requestModifier) {
        SDWebImageDownloaderRequestModifier *modifier = [SDWebImageDownloaderRequestModifier requestModifierWithBlock:requestModifier];
        context = @{SDWebImageContextDownloadRequestModifier:modifier};
    }
    
    SDWebImageDownloaderOptions options = SDWebImageDownloaderLowPriority | SDWebImageDownloaderAvoidDecodeImage;
    
    SDWebImageDownloadToken *token = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:options context:context progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progress) progress(receivedSize, expectedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            if (failed) failed(error, finished);
        } else {
            if (success) success(data, finished);
        }
    }];
    return token;
}

- (void)cancelTaskWithDownloadToken:(id)token {
    if (token && [token isKindOfClass:SDWebImageDownloadToken.class]) {
        [((SDWebImageDownloadToken *)token) cancel];
    }
}

- (void)storeToDiskWithImageData:(NSData *)data forKey:(NSURL *)key {
    if (!key) return;
    NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:key];
    if (!cacheKey) return;
    
    LC_DISPATCH_ASYNC(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:cacheKey];
    })
}

- (void)queryCacheOperationForKey:(NSURL *)key completed:(LCWebImageCacheQueryCompletedBlock)completed {
#define QUERY_CACHE_FAILED if (completed) {completed(nil, nil); return;}
    if (!key) QUERY_CACHE_FAILED
        NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:key];
    if (!cacheKey) QUERY_CACHE_FAILED
#undef QUERY_CACHE_FAILED
        
        // 'NSData' of image must be read to ensure decoding correctly.
        SDImageCacheOptions options = SDImageCacheQueryMemoryData | SDImageCacheAvoidDecodeImage;
    [[SDImageCache sharedImageCache] queryCacheOperationForKey:cacheKey options:options done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        if (completed) completed(image, data);
    }];
}

@end

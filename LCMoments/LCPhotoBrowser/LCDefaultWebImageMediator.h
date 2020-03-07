//
//  LCDefaultWebImageMediator.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSURLRequest * _Nullable (^LCWebImageRequestModifierBlock)(NSURLRequest *request);
typedef void(^LCWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^LCWebImageSuccessBlock)(NSData * _Nullable imageData, BOOL finished);
typedef void(^LCWebImageFailedBlock)(NSError * _Nullable error, BOOL finished);
typedef void(^LCWebImageCacheQueryCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable imageData);

@protocol LCWebImageMediator <NSObject>

@required

/**
 下载图片

 @param URL 图片地址
 @param requestModifier 修改默认 NSURLRequest 的闭包
 @param progress 进度回调
 @param success 成功回调
 @param failed 失败回调
 @return 下载 token (可为空)
 */
- (id)downloadImageWithURL:(NSURL *)URL requestModifier:(nullable LCWebImageRequestModifierBlock)requestModifier progress:(LCWebImageProgressBlock)progress success:(LCWebImageSuccessBlock)success failed:(LCWebImageFailedBlock)failed;

/**
 缓存图片数据到磁盘

 @param data 图片数据
 @param key 缓存标识
 */
- (void)storeToDiskWithImageData:(nullable NSData *)data forKey:(NSURL *)key;

/**
 读取图片数据

 @param key 缓存标识
 @param completed 读取回调
 */
- (void)queryCacheOperationForKey:(NSURL *)key completed:(LCWebImageCacheQueryCompletedBlock)completed;

@optional

/**
 取消下载
 
 @param token 下载 token
 */
- (void)cancelTaskWithDownloadToken:(id)token;

@end

@interface LCDefaultWebImageMediator : NSObject

@end

NS_ASSUME_NONNULL_END

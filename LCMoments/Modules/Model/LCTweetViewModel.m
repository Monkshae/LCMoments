//
//  LCTweetViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCTweetViewModel.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "LCUserInfoModel.h"
#import "LCTweetModel.h"
#import "LCCommentSectionViewModel.h"
#import "LCContentSectionViewModel.h"
#import "LCCacheUtil.h"

static NSString * const kUserInfoUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/jsmith.json";
static NSString * const kTweetsUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/tweets.json";
static NSString * const kTweetsCacheKey = @"kTweetsCacheKey";
static NSString * const kUserInfoCacheKey = @"kUserInfoCacheKey";


@interface LCTweetViewModel ()

@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LCTweetViewModel

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)requestUserInfo:(void (^)(LCUserInfoModel * _Nonnull))successBlock
             faileBlock:(void (^)(NSError * _Nullable))faileBlock {
    LCUserInfoModel * cacheInfo = [LCCacheUtil readCustomObjectsFrom:kUserInfoCacheKey];
    if (cacheInfo) {
        return successBlock(cacheInfo);
    } else {
        NSURL *URL = [NSURL URLWithString:kUserInfoUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask =[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                faileBlock(error);
            } else {
                [SVProgressHUD dismiss];
                LCUserInfoModel *info = [LCUserInfoModel mj_objectWithKeyValues:responseObject];
                [LCCacheUtil saveCustomObjects:info fileName:kUserInfoCacheKey];
                successBlock(info);
            }
        }];
        [dataTask resume];
    }
}

- (void)requestTweetsWithSuccessBlock:(void (^)(NSArray * _Nonnull))successBlock
                           faileBlock:(void (^)(NSError * _Nullable))faileBlock {
    
    NSArray * cacheTweets = [LCCacheUtil readCustomObjectsFrom:kTweetsCacheKey];
    if (cacheTweets.count > 0) {
        successBlock(cacheTweets);
    } else {
        NSURL *URL = [NSURL URLWithString:kTweetsUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
              faileBlock(error);
          } else {
              [SVProgressHUD dismiss];
              NSArray <LCTweetModel *> *tweets = [LCTweetModel mj_objectArrayWithKeyValuesArray:responseObject];
              [LCCacheUtil saveCustomObjects:tweets fileName:kTweetsCacheKey];
              successBlock(tweets);
          }
        }];
        [dataTask resume];
    }
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

@end

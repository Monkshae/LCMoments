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

static NSString * const kUserInfoUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/jsmith.json";
static NSString * const kTweetsUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/tweets.json";

@interface LCTweetViewModel ()

@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) LCUserInfoModel *userInfo;
@property (nonatomic, strong) NSArray <LCContentCellViewModel *> *tweetList;

@end

@implementation LCTweetViewModel

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)requestUserInfo {
      NSURL *URL = [NSURL URLWithString:kUserInfoUrl];
      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
      NSURLSessionDataTask *dataTask =[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
          } else {
              [SVProgressHUD dismiss];
              LCUserInfoModel *info = [LCUserInfoModel mj_objectWithKeyValues:responseObject];
              self.userInfo = info;
              
          }
          
      }];
      [dataTask resume];
}

- (void)requestTweetsWithSuccessBlock:(void(^)(NSArray<LCContentCellViewModel *> *))successBlock {
      NSURL *URL = [NSURL URLWithString:kTweetsUrl];
      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
      NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
          } else {
              [SVProgressHUD dismiss];
              NSArray <LCTweetModel *> *tweets = [LCTweetModel mj_objectArrayWithKeyValuesArray:responseObject];
              
              NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:tweets.count];
              [tweets enumerateObjectsUsingBlock:^(LCTweetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  LCContentCellViewModel *cellViewModel = [[LCContentCellViewModel alloc]initWithTweetModel:obj];
                  if (obj.sender.username.length > 0) {
                      [tempArray addObject:cellViewModel];
                  }
              }];
              self.tweetList = [tempArray  mutableCopy];
              successBlock(self.tweetList);
          }
      }];
      [dataTask resume];
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

@end

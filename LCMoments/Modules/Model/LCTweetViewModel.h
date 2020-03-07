//
//  LCTweetViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCDefine.h"
#import "LCContentCellViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface LCTweetViewModel : NSObject

- (void)requestUserInfo:(void(^)(LCUserInfoModel *infoModel))successBlock faileBlock:(void(^)(NSError * _Nullable error))faileBlock;

- (void)requestTweetsWithSuccessBlock:(void(^)(NSArray *list))successBlock faileBlock:(void(^)(NSError * _Nullable error))faileBlock;

@end

NS_ASSUME_NONNULL_END

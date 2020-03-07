//
//  LCTweetViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"
#import "LCContentCellViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface LCTweetViewModel : NSObject

//@property (nonatomic, readonly) NSArray <LCContentCellViewModel *> *tweetList;

- (void)requestUserInfo;

- (void)requestTweetsWithSuccessBlock:(void(^)(NSArray*))successBlock;

@end

NS_ASSUME_NONNULL_END
